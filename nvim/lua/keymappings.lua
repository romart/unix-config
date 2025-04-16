local utils = require('utils')
local wk = require("which-key")

wk.add
{
  { "<F2>",  utils.toggle_line_numbers, desc = "Switch relative-absolute line numbers" },
  { "<C-s>", ":w<CR>",                  desc = "Save current buffer",                  mode = "n" },
  { "<C-q>", ":bd<CR>",                 desc = "Close current buffer",                 mode = "n" },
  { "<A-f>", utils.toggle_auto_format,  desc = "Toggle Auto-format",                   mode = "n" },
  { "D", function()
    vim.diagnostic.open_float(0, { scope = "line" })
  end, desc = "Show diagnostics on current line", mode = "n" },
  -- window navigation
  { "<C-h>", "<C-w>h", desc = "Switch window (left)",  mode = "n" },
  { "<C-j>", "<C-w>j", desc = "Switch window (down)",  mode = "n" },
  { "<C-k>", "<C-w>k", desc = "Switch window (up)",    mode = "n" },
  { "<C-l>", "<C-w>l", desc = "Switch window (right)", mode = "n" }
}
