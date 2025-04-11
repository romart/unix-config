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

return utils
