if vim.fn.has("nvim-0.12") == 0 or not vim.pack then
  error("This configuration requires Neovim 0.12 or newer")
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('settings')
require('plugins')
require('keymappings')
require('autosaver')

vim.cmd("colorscheme tokyonight-night")
