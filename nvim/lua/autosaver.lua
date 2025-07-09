

local autosave_enabled = true
local force_tsr = false

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
  if autosave_enabled then
    if force_tsr then
      trailings_cleaner();
    end
    if vim.bo.modified and vim.bo.modifiable and vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
      local pos = vim.api.nvim_win_get_cursor(0)  -- save cursor
      vim.cmd("silent write")

      vim.schedule(function()
        -- due to 'write' command is async so we need to make sure cursor restoration
        -- happens after write
        vim.api.nvim_win_set_cursor(0, pos)
      end)
    end
  end
end

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertLeave" }, {
  pattern = "*",
  callback = autosave,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = trailings_cleaner,
})

vim.api.nvim_create_user_command("ToggleAutosave", toggle_autosave, {})

local min_autosave_interval = 1 -- 1 sec
local autosave_interval = 30 -- 30 secs

local function autosave_loop()
  vim.defer_fn(function()
    autosave()
    autosave_loop()
  end, autosave_interval * 1000)
end

autosave_loop()

vim.api.nvim_create_user_command("SetAutoSaveInterval", function(opts)
  local number = tonumber(opts.args)
  if not number then
    vim.notify("Invalid number: " .. opts.args, vim.log.levels.ERROR)
    return
  end

  number = math.max(number, min_autosave_interval);
  -- Do something with the number
  print("Change auto save interval from " .. autosave_interval .. " to " .. number .. " seconds")
  autosave_interval = number
  autosave_loop()
end, {
  nargs = 1,       -- Require exactly one argument
  complete = nil,  -- No completion needed
})

