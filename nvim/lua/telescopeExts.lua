
local M = {}



local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local utils = require("toggleterm-manager").utils


local toggleterm = require("toggleterm")
local terms = require("toggleterm.terminal")

local function get_selected_lines(selection_type)
  local tt_utils = require("toggleterm.utils")
  local api = vim.api
  local fn = vim.fn
  local lines = {}
  -- Beginning of the selection: line number, column number
  local start_line, start_col
  if selection_type == "single_line" then
    start_line, start_col = unpack(api.nvim_win_get_cursor(0))
    start_col = start_col + 1
    table.insert(lines, fn.getline(start_line))
  else
    local res = tt_utils.get_line_selection("visual")
    start_line, start_col = unpack(res.start_pos)
    if selection_type == "visual_lines" then
      lines = res.selected_lines
    elseif selection_type == "visual_selection" then
      lines = tt_utils.get_visual_selection(res, true)
    end
  end

  if not lines or not next(lines) then return nil end
  return lines
end

function M.send_selection_to_term(mode, opts)
  local terminals = terms.get_all(true)
  local trim_spaces = true
  if #terminals <= 1 then
    toggleterm.send_lines_to_terminal(mode, trim_spaces, { args = #terminals })
    terminals = terms.get_all(true)
    local term = terminals[1]
    if not term:is_open() then
      term:open()
    end
    return
  end
  local lines = get_selected_lines(mode)
  if lines == nil then return end

	local config = require("config").options
	-- set origin window, which will need to be retrieved in some actions (actions/init.lua)
	require("toggleterm.ui").set_origin_window()

	local picker = pickers.new(opts, {
		prompt_title = config.titles.prompt,
		results_title = config.display_mappings and utils.format_results_title(config.mappings)
			or config.titles.results,
		preview_title = config.titles.preview,
		previewer = conf.grep_previewer(opts),
		finder = utils.create_finder(),
		sorter = conf.generic_sorter(opts),
		attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local term = require("utils").find(terminals, function (term)
         return term.bufnr == selection.bufnr
        end)
        if not term then return end
        -- feed lines into terminal
        for _, line in ipairs(lines) do
          local l = line:gsub("^%s+", ""):gsub("%s+$", "") or line
          toggleterm.exec(l, term.id)
        end
        if not term:is_open() then
          term:open()
        end
      end)
			return true
		end,
	})
	picker:find()
end

return M
