-- general settings
local utils = require('utils')

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ts = 2
vim.opt.cmdheight = 0
vim.opt.termguicolors = true
vim.opt.scrolloff = 5
vim.opt.signcolumn = 'no'
vim.opt.ignorecase = true
vim.opt.cursorline = true
vim.opt.clipboard = 'unnamedplus'

vim.opt.guicursor = "n-v-c:block-blinkon1-CursorInsert,i:block-CursorInsert"

vim.opt.shell = os.getenv('SHELL')
vim.opt.shellcmdflag = '-c'
vim.opt.shellquote = ''
vim.opt.shellxquote = ''

-- stop right-shift when errors/warning appear
vim.o.completeopt = "menuone,noselect,preview"

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.bo.softtabstop = 2

vim.cmd("autocmd FileType sql setlocal noautoindent")
vim.cmd("autocmd FileType sql setlocal nosmartindent")
vim.cmd("autocmd FileType sql setlocal nocindent")

vim.g.python3_host_prog = utils.get_python_path()
vim.g.disable_autoformat = true
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

vim.opt.fillchars = {
  vert = " ", horiz = " ", horizup = " ", horizdown = " ", vertleft = " ", vertright = " ", verthoriz = " "
}

local function sync_bg_with_terminal()
  local bg = "#000000"

  local groups = {
    "Normal",
    "NormalNC",
    "NormalFloat",
    "SignColumn",
    "LineNr",
    "CursorLineNr",
    "EndOfBuffer",
    "StatusLine",
    "StatusLineNC",
  }

  for _, group in ipairs(groups) do
    vim.api.nvim_set_hl(0, group, { bg = bg })
  end
end

-- run after colorscheme so it overrides theme defaults
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = sync_bg_with_terminal,
})
