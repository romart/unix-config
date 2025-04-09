local utils = require('utils')
local wk = require("which-key")


wk.add({
  { "<leader>z",  group = "Zen" },
  { "<leader>zz", ":ZenMode<CR>", desc = "Enter/Exit" }
})

wk.add(
  {
    { "<leader>y",  group = "Yazi" },
    { "<leader>yn", "<cmd>Yazi<cr>",        desc = "Open yazi at the current file" },
    { "<leader>yt", "<cmd>Yazi toggle<CR>", desc = "Resume the last yazi session" },
    { "<leader>yw", "<cmd>Yazi cwd<cr>",    desc = "Open the file manager in nvim's working directory" },
  }
)


local builtin = require("telescope.builtin")

local function find_files()
  builtin.find_files({
    find_command = { 'rg', '--files', '--hidden', '-g', '!.git' }
  })
end

wk.add(
  {
    { "<leader>",   group = "Telescope" },
    { "<leader>B",  ":Telescope buffers<cr>",         desc = "Open Buffers" },
    { "<leader>H",  ":Telescope command_history<cr>", desc = "Command History" },
    { "<leader>M",  ":Telescope marks<cr>",           desc = "Marks" },
    { "<leader>R",  ":Telescope registers<cr>",       desc = "Registers" },
    { "<leader>ds", builtin.lsp_document_symbols,     desc = "Current Buffer Symbols" },
    { "<leader>fb", ":Telescope buffers<cr>",         desc = "File Browser" },
    { "<leader>fd", builtin.diagnostics,              desc = "Diagnostics" },
    { "<leader>fg", builtin.live_grep,                desc = "Live Grep" },
    { "<leader>fv", builtin.help_tags,                desc = "Help Tags" },
    { "<leader>jk", find_files,                       desc = "Find Files" },
    { "<leader>ws", builtin.lsp_workspace_symbols,    desc = "Workspace Symbols" },
  }
)

local flash = require("flash")

wk.add(
  {
    { "<leader>l",  group = "Flash" },
    { "<leader>lr", flash.remote,            desc = "Remote Flash",            mode = "o" },
    { "<leader>lS", flash.toggle,            desc = "Treesitter Flash Search", mode = "c" },
    { "<leader>lR", flash.treesitter_search, desc = "Treesitter Search",       mode = { "o", "x" } },
    { "<leader>ls", flash.jump,              desc = "Flash Jump",              mode = { "n", "o", "x" } },
    { "<leader>lt", flash.treesitter,        desc = "Flash Treesitter",        mode = { "n", "o", "x" } },
  }
)


function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-t>', [[<Cmd>ToggleTerm<CR>]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

local function start_new_term()
  local name = vim.fn.input("Enter Terminal name: ")
  vim.cmd("TermNew direction=float name=\"" .. name .. "\"")
end


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

local function send_selection_to_term(mode)
  local terminals = terms.get_all(true)
  local trim_spaces = true
  if #terminals <= 1 then
    return toggleterm.send_lines_to_terminal(mode, trim_spaces, { args = #terminals })
  end
  local lines = get_selected_lines(mode)
  if lines == nil then return end
  vim.ui.select(terminals, {
    prompt = "Please select a terminal to copy text: ",
    format_item = function(term) return term.id .. ": " .. term:_display_name() end,
  }, function(_, idx)
    local term = terminals[idx]
    if not term then return end
    -- feed lines into terminal
    for _, line in ipairs(lines) do
      local l = line:gsub("^%s+", ""):gsub("%s+$", "") or line
      toggleterm.exec(l, idx)
    end
    if not term:is_open() then
      term:open()
    end
  end)
end

wk.add({
  { "<C-t>",      ":ToggleTerm direction=float<CR>",                         desc = "Toggle default floating terminal",              mode = { "n" } },
  { "<A-t>",      start_new_term,                                            desc = "Create New terminal",                           mode = "n" },
  { "<leader>fs", ":TermSelect<CR>",                                         desc = "List Open Terminals",                           mode = "n" },
  { "<space>s",   function() send_selection_to_term("single_line") end,      desc = "Send current line into selected terminal",      mode = "n" },
  { "<space>s",   function() send_selection_to_term("visual_lines") end,     desc = "Send selected lines into selected terminal",    mode = "x" },
  { "<space>s",   function() send_selection_to_term("visual_selection") end, desc = "Send current selection into selected terminal", mode = "v" },
})

wk.add(
  {
    { "gd",        vim.lsp.buf.definition,                     desc = "Goto Definition",                      mode = "n" },
    { "gD",        vim.lsp.buf.declaration,                    desc = "Goto Declaration",                     mode = "n" },
    { "<F2>",      utils.toggle_line_numbers,                  desc = "Switch relative-absolute line numbers" },
    { "<C-n>",     ":NvimTreeToggle<CR>",                      desc = "Tree Toggle",                          mode = { "i", "n" } },
    { "<C-s>",     ":w<CR>",                                   desc = "Save current buffer",                  mode = "n" },
    { "<C-q>",     ":bd<CR>",                                  desc = "Close current buffer",                 mode = "n" },
    { "<leader>?", function() wk.show({ global = false }) end, desc = "Buffer Local Keymaps (which-key)",     mode = "n" },
    { "<A-f>",     utils.toggle_auto_format,                   desc = "Toggle Auto-format",                   mode = "n" }
  }
)

wk.add(
  {
    { "<C-h>", "<C-w>h", desc = "Switch window (left)",  mode = "n" },
    { "<C-j>", "<C-w>j", desc = "Switch window (down)",  mode = "n" },
    { "<C-k>", "<C-w>k", desc = "Switch window (up)",    mode = "n" },
    { "<C-l>", "<C-w>l", desc = "Switch window (right)", mode = "n" }
  }
)


local dap = require("dap")
local dapui = require("dapui")

local function terminate_debug()
  dap.terminate()
  dapui.close()
end

wk.add(
  {
    { "<F5>",      dap.continue,          desc = "Continue Execution", mode = "n" },
    { "<F9>",      dap.toggle_breakpoint, desc = "Toggle Breakpoint",  mode = "n" },
    { "<F8>",      dap.step_over,         desc = "Step Over",          mode = "n" },
    { "<F10>",     dap.step_into,         desc = "Step Into",          mode = "n" },
    { "<F11>",     dap.step_out,          desc = "Step Out",           mode = "n" },
    { "<F12>",     terminate_debug,       desc = "Terminate",          mode = "n" },
    { "<leader>P", dap.pause,             desc = "Pause",              mode = "n" },
  }
)

local ls = require("luasnip")

wk.add({
  { "<C-K>", ls.expand,                  mode = "i",          silent = true, desc = "Expand Snippet" },
  { "<C-L>", function() ls.jump(1) end,  mode = { "i", "s" }, silent = true, desc = "Jump Forward" },
  { "<C-J>", function() ls.jump(-1) end, mode = { "i", "s" }, silent = true, desc = "Jump Backward" },
  {
    "<C-E>",
    function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end,
    mode = { "i", "s" },
    silent = true,
    desc = "Change active choice"
  },
})
