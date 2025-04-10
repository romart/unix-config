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
    { "<leader>B",  builtin.buffers,                     desc = "Open Buffers" },
    { "<leader>H",  builtin.command_history,             desc = "Command History" },
    { "<leader>M",  builtin.marks,                       desc = "Marks" },
    { "<leader>R",  builtin.registers,                   desc = "Registers" },
    { "<leader>J",  builtin.jumplist,                    desc = "Jump List" },
    { "<leader>S",  builtin.search_history,              desc = "Search History" },
    { "<leader>F",  find_files,                          desc = "Find Files" },
    { "<leader>T",  ":Telescope toggleterm_manager<CR>", desc = "List Open Terminals" },
    { "<leader>ds", builtin.lsp_document_symbols,        desc = "Current Buffer Symbols" },
    { "<leader>gs", builtin.grep_string,                 desc = "Grep string (udnder cursor)" },
    { "<leader>ww", builtin.treesitter,                  desc = "Function names, variables" },
    { "<leader>fr", builtin.lsp_references,              desc = "Symbol (under cursor) references" },
    { "<leader>fd", builtin.diagnostics,                 desc = "Diagnostics" },
    { "<leader>fg", builtin.live_grep,                   desc = "Live Grep" },
    { "<leader>fv", builtin.help_tags,                   desc = "Help Tags" },
    { "<leader>ws", builtin.lsp_workspace_symbols,       desc = "Workspace Symbols" },
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

local function start_new_term()
  local name = vim.fn.input("Enter Terminal name: ")
  vim.cmd("TermNew direction=float name=\"" .. name .. "\"")
end


local telutil = require("telescopeExts")
local themes = require("telescope.themes")

wk.add({
  { "<C-t>",    ":ToggleTerm direction=float<CR>",                                                       desc = "Toggle default floating terminal",              mode = { "n" } },
  { "<A-t>",    start_new_term,                                                                          desc = "Create New terminal",                           mode = "n" },
  { "<space>c", function() telutil.send_selection_to_term("single_line", themes.get_cursor {}) end,      desc = "Send current line into selected terminal",      mode = "n" },
  { "<space>c", function() telutil.send_selection_to_term("visual_lines", themes.get_cursor {}) end,     desc = "Send selected lines into selected terminal",    mode = "x" },
  { "<space>c", function() telutil.send_selection_to_term("visual_selection", themes.get_cursor {}) end, desc = "Send current selection into selected terminal", mode = "v" },
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
