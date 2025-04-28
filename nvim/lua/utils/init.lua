local utils = {}

--- get the operating system name
--- "windows", "mac", "linux"
function utils.get_os()
  local uname = vim.loop.os_uname()
  local os_name = uname.sysname
  if os_name == "Windows_NT" then
    return "windows"
  elseif os_name == "Darwin" then
    return "mac"
  else
    return "linux"
  end
end

function utils.expand_path(path)
  if path:sub(1, 1) == "~" then
    return os.getenv("HOME") .. path:sub(2)
  end
  return path
end

function utils.center_in(outer, inner)
  return (outer - inner) / 2
end

function utils.toggle_line_numbers()
  if vim.wo.number then
    if vim.wo.relativenumber then
      vim.wo.relativenumber = false
    else
      vim.wo.relativenumber = true
    end
  end
end

function utils.load_config_from_json(file_path)
  local file = vim.fn.readfile(file_path)
  local json_content = table.concat(file, '\n') -- Convert the file to a string

  -- Decode the JSON content into a Lua table
  local success, config = pcall(vim.fn.json_decode, json_content)
  if not success then
    print("Error parsing JSON configuration.")
    return nil
  end
  return config
end

function utils.get_python_path()
  -- Check if there's an active virtual environment
  local venv_path = os.getenv("VIRTUAL_ENV")
  if venv_path then
    return venv_path .. "/bin/python3"
  else
    -- get os name
    local os_name = require("utils").get_os()
    -- get os interpreter path
    if os_name == "windows" then
      return "C:/python312"
    elseif os_name == "linux" then
      return "/usr/bin/python3"
    else
      return "/Library/Frameworks/Python.framework/Versions/3.11/bin/python3"
    end
    -- Fallback to global Python interpreter
  end
end

function utils.toggle_auto_format()
  if vim.g.disable_autoformat then
    vim.g.disable_autoformat = false
    vim.notify("Auto-format enabled", vim.log.levels.INFO)
  else
    vim.g.disable_autoformat = true
    vim.notify("Auto-format disabled", vim.log.levels.INFO)
  end
end

function utils.find(tbl, predicate)
    for _, v in ipairs(tbl) do
        if predicate(v) then
            return v
        end
    end
    return nil  -- Return nil if no element matches the predicate
end

local function extract_visual_selection(res, mode)
  local start_line, start_col = unpack(res.start_pos)
  local end_line, end_col = unpack(res.end_pos)

  -- line-visual
  -- return lines encompassed by the selection
  if mode == "V" then
    -- vim.notify("Visual Line mode.....")
    return vim.api.nvim_buf_get_text(0, start_line - 1, start_col, end_line - 1, end_col, {})
  end

  -- exclude the last col of the block if "selection" is set to "exclusive"
  if vim.opt.selection:get() == "exclusive" then end_col = end_col - 1 end

  if mode == "v" then
    -- vim.notify("Visual mode.....")
    -- regular-visual
    -- return the buffer text encompassed by the selection
    return vim.api.nvim_buf_get_text(0, start_line - 1, start_col - 1, end_line - 1, end_col, {})
  end

  -- block-visual
  -- return the lines encompassed by the selection, each truncated by the start and end columns
  if mode == "\x16" then
    -- vim.notify("Visual Block.....")

    -- exchange start and end columns for proper substring indexing if needed
    -- e.g. instead of str:sub(10, 5), do str:sub(5, 10)
    local lines = vim.api.nvim_buf_get_text(0, start_line - 1, start_col, end_line - 1, end_col, {})
    if start_col > end_col then
      start_col, end_col = end_col, start_col
    end
    -- iterate over lines, truncating each one
    return vim.tbl_map(function(line) return line:sub(start_col, end_col) end, lines)
  end
end

local function get_selection_coordinates()
  -- '< marks are only updated when one leaves visual mode.
  -- When calling lua functions directly from a mapping, need to
  -- explicitly exit visual with the escape key to ensure those marks are
  -- accurate.
  vim.cmd("normal! ")

  -- Get the start and the end of the selection
  local start_line, start_col = unpack(vim.fn.getpos("'<"), 2, 3)
  local end_line, end_col = unpack(vim.fn.getpos("'>"), 2, 3)

  return {
    start_pos = { start_line, start_col },
    end_pos = { end_line, end_col },
  }
end

function utils.get_visual_selected(merge)
  local selected_lines = get_selection_coordinates()
  local mode = vim.fn.visualmode()
  local extracted_lines = extract_visual_selection(selected_lines, mode)
  if merge then
    return table.concat(extracted_lines, "\n")
  end

  return extracted_lines
end


return utils
