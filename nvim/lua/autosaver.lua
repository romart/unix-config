local utils = require('utils')
local uv = vim.uv or vim.loop

local autosave_enabled = true
local force_tsr = false
local autosave_in_progress = false
local autosave_timer -- uv timer handle
local buf_mtime_ns = {}

local function notify_err(msg)
  vim.schedule(function()
    vim.notify(msg, vim.log.levels.ERROR)
  end)
end

local function get_mtime_ns(path)
  local st, _, code = uv.fs_stat(path)
  if not st and code == "ENOENT" then return false end
  if not st or not st.mtime then return nil end
  local sec = st.mtime.sec or st.mtime.tv_sec
  local nsec = st.mtime.nsec or st.mtime.tv_nsec or 0
  if not sec then return nil end
  return tostring(sec) .. ":" .. tostring(nsec)
end

local function update_buf_mtime(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" then return end
  buf_mtime_ns[buf] = get_mtime_ns(name)
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePost" }, {
  callback = function(args)
    update_buf_mtime(args.buf)
  end,
})

vim.api.nvim_create_autocmd("BufWipeout", {
  callback = function(args)
    buf_mtime_ns[args.buf] = nil
  end,
})

for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  if vim.api.nvim_buf_is_loaded(buf) and not vim.bo[buf].modified then
    update_buf_mtime(buf)
  end
end

local toggle_autosave = function()
  autosave_enabled = not autosave_enabled
  print("AutoSave: " .. (autosave_enabled and "ON" or "OFF"))
end

local trailings_cleaner = function()
  if vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
    local mode = vim.api.nvim_get_mode().mode
    if mode:match("i") or mode:match("R") then
      -- skip to avoid annoying cursor jumps
      force_tsr = true
      return
    end
    -- if TSR was skipped we probably want to apply it before saving
    force_tsr = false
    vim.cmd([[%s/\s\+$//e]])                     -- remove trailing spaces
  end
end

local autosave = function()
  if not autosave_enabled then return end
  if autosave_in_progress then return end
  if utils.is_git_commit() then return end

  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()
  local bufObj = vim.bo[buf];

  if not (bufObj.modified and bufObj.modifiable and bufObj.buftype == "") then
    return
  end

  local path = vim.api.nvim_buf_get_name(buf)
  if path == "" then return end

  -- Avoid clobbering external edits (Codex, git checkout, formatters, etc.)
  local disk_mtime = get_mtime_ns(path)
  local known_mtime = buf_mtime_ns[buf]
  if disk_mtime == nil
      or (known_mtime == nil and disk_mtime ~= false)
      or (known_mtime ~= nil and disk_mtime ~= known_mtime) then
    return
  end

  autosave_in_progress = true

  -- Always release the "lock", no matter what happens.
  local function release()
    autosave_in_progress = false
  end

  local ok, err = pcall(function()
    local pos = vim.api.nvim_win_get_cursor(win)

    if force_tsr then
      local ok_tsr, err_tsr = pcall(trailings_cleaner)
      if not ok_tsr then
        notify_err("Autosave: trailing-space cleaner failed:\n" .. tostring(err_tsr))
        -- continue; a failure here shouldn't block saving
      end
    end

    local ok_upd, err_upd = pcall(vim.cmd, "silent update")
    if not ok_upd then
      notify_err("Autosave: write failed:\n" .. tostring(err_upd))
      -- Restore the cursor without accepting a new disk timestamp.
    end

    vim.schedule(function()
      -- Cursor restore only if still same win/buf
      if vim.api.nvim_get_current_buf() == buf and vim.api.nvim_get_current_win() == win then
        local ok_cur, err_cur = pcall(vim.api.nvim_win_set_cursor, win, pos)
        if not ok_cur then
          notify_err("Autosave: cursor restore failed:\n" .. tostring(err_cur))
        end
      end

      release()
    end)
  end)

  if not ok then
    -- Something unexpected exploded before the scheduled cleanup ran.
    notify_err("Autosave: unexpected error:\n" .. tostring(err))
    release()
  end
end

-- Autosave triggers
vim.api.nvim_create_autocmd({ "BufLeave", "InsertLeave" }, {
  pattern = "*",
  callback = autosave,
})

-- Reload externally changed files when coming back (Codex edits etc.)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  pattern = "*",
  callback = function()
    pcall(vim.cmd, "checktime")
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = trailings_cleaner,
})

vim.api.nvim_create_user_command("ToggleAutosave", toggle_autosave, {})

local min_autosave_interval = 1 -- 1 sec
local autosave_interval = 30 -- 30 secs

local function start_autosave_timer()
  if autosave_timer then
    autosave_timer:stop()
    autosave_timer:close()
    autosave_timer = nil
  end

  autosave_timer = uv.new_timer()
  autosave_timer:start(
    autosave_interval * 1000,
    autosave_interval * 1000,
    vim.schedule_wrap(function()
      autosave()
    end)
  )
end

start_autosave_timer()

vim.api.nvim_create_user_command("SetAutoSaveInterval", function(opts)
  local number = tonumber(opts.args)
  if not number then
    vim.notify("Invalid number: " .. opts.args, vim.log.levels.ERROR)
    return
  end

  number = math.max(number, min_autosave_interval)
  print(("Change auto save interval from %s to %s seconds"):format(autosave_interval, number))
  autosave_interval = number
  start_autosave_timer()
end, { nargs = 1 })

