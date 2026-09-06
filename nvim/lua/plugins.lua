-- Installation, updates, and revision tracking are handled by vim.pack.
local specs = {
  { src = "https://github.com/MunifTanjim/nui.nvim", name = "nui.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim", name = "plenary.nvim" },
  { src = "https://github.com/folke/trouble.nvim", name = "trouble.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim", name = "telescope.nvim", version = "v0.2.1" },
  { src = "https://github.com/jackMort/ChatGPT.nvim", name = "ChatGPT.nvim" },
  { src = "https://github.com/norcalli/nvim-colorizer.lua", name = "nvim-colorizer.lua" },
  { src = "https://github.com/numToStr/Comment.nvim", name = "Comment.nvim" },
  { src = "https://github.com/hrsh7th/cmp-buffer", name = "cmp-buffer" },
  { src = "https://github.com/hrsh7th/cmp-nvim-lsp", name = "cmp-nvim-lsp" },
  { src = "https://github.com/hrsh7th/cmp-nvim-lsp-signature-help", name = "cmp-nvim-lsp-signature-help" },
  { src = "https://github.com/kdheepak/cmp-latex-symbols", name = "cmp-latex-symbols" },
  { src = "https://github.com/windwp/nvim-autopairs", name = "nvim-autopairs" },
  { src = "https://github.com/L3MON4D3/LuaSnip", name = "LuaSnip" },
  { src = "https://github.com/hrsh7th/nvim-cmp", name = "nvim-cmp" },
  { src = "https://github.com/stevearc/conform.nvim", name = "conform.nvim" },
  { src = "https://github.com/mfussenegger/nvim-dap", name = "nvim-dap" },
  { src = "https://github.com/nvim-neotest/nvim-nio", name = "nvim-nio" },
  { src = "https://github.com/rcarriga/nvim-dap-ui", name = "nvim-dap-ui" },
  { src = "https://github.com/j-hui/fidget.nvim", name = "fidget.nvim" },
  { src = "https://github.com/folke/flash.nvim", name = "flash.nvim" },
  { src = "https://github.com/m4xshen/hardtime.nvim", name = "hardtime.nvim" },
  { src = "https://github.com/williamboman/mason.nvim", name = "mason.nvim" },
  { src = "https://github.com/williamboman/mason-lspconfig.nvim", name = "mason-lspconfig.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig", name = "nvim-lspconfig" },
  { src = "https://github.com/echasnovski/mini.icons", name = "mini.icons" },
  { src = "https://github.com/nvim-lualine/lualine.nvim", name = "lualine.nvim" },
  { src = "https://github.com/saadparwaiz1/cmp_luasnip", name = "cmp_luasnip" },
  { src = "https://github.com/rafamadriz/friendly-snippets", name = "friendly-snippets" },
  { src = "https://github.com/onsails/lspkind.nvim", name = "lspkind.nvim" },
  { src = "https://github.com/echasnovski/mini.surround", name = "mini.surround" },
  { src = "https://github.com/echasnovski/mini.nvim", name = "mini.nvim", version = vim.version.range('*') },
  { src = "https://github.com/nvim-tree/nvim-web-devicons", name = "nvim-web-devicons" },
  { src = "https://github.com/nvim-tree/nvim-tree.lua", name = "nvim-tree.lua" },
  { src = "https://github.com/HiPhish/rainbow-delimiters.nvim", name = "rainbow-delimiters.nvim" },
  { src = "https://github.com/NStefan002/screenkey.nvim", name = "screenkey.nvim", version = vim.version.range("*") },
  { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim", name = "telescope-fzf-native.nvim" },
  { src = "https://github.com/nvim-telescope/telescope-ui-select.nvim", name = "telescope-ui-select.nvim" },
  { src = "https://github.com/folke/tokyonight.nvim", name = "tokyonight.nvim" },
  { src = "https://github.com/blazkowolf/gruber-darker.nvim", name = "gruber-darker.nvim" },
  { src = "https://github.com/rktjmp/lush.nvim", name = "lush.nvim" },
  { src = "https://github.com/zenbones-theme/zenbones.nvim", name = "zenbones.nvim" },
  { src = "https://github.com/ellisonleao/gruvbox.nvim", name = "gruvbox.nvim" },
  { src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
  { src = "https://github.com/tjdevries/colorbuddy.nvim", name = "colorbuddy.nvim" },
  { src = "https://github.com/gmr458/cold.nvim", name = "cold.nvim" },
  { src = "https://github.com/vague2k/vague.nvim", name = "vague.nvim" },
  { src = "https://github.com/jnurmine/Zenburn", name = "Zenburn" },
  { src = "https://github.com/RRethy/base16-nvim", name = "base16-nvim" },
  { src = "https://github.com/akinsho/toggleterm.nvim", name = "toggleterm.nvim" },
  { src = "https://github.com/ryanmsnyder/toggleterm-manager.nvim", name = "toggleterm-manager.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", name = "nvim-treesitter", version = "main" },
  { src = "https://github.com/Wansmer/treesj", name = "treesj" },
  { src = "https://github.com/folke/which-key.nvim", name = "which-key.nvim" },
  { src = "https://github.com/mikavilpas/yazi.nvim", name = "yazi.nvim" },
  { src = "https://github.com/folke/zen-mode.nvim", name = "zen-mode.nvim" },
}

local function run(command, cwd)
  local result = vim.system(command, { cwd = cwd, text = true }):wait()
  if result.code ~= 0 then
    error(table.concat(command, " ") .. " failed:\n" .. (result.stderr or result.stdout or ""))
  end
end

vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("PluginBuilds", { clear = true }),
  callback = function(event)
    local change = event.data
    if change.kind ~= "install" and change.kind ~= "update" then return end
    if change.spec.name == "LuaSnip" then
      run({ "make", "install_jsregexp" }, change.path)
    elseif change.spec.name == "telescope-fzf-native.nvim" then
      run({ "cmake", "-S", ".", "-B", "build", "-DCMAKE_BUILD_TYPE=Release" }, change.path)
      run({ "cmake", "--build", "build", "--config", "Release" }, change.path)
    elseif change.spec.name == "nvim-treesitter" then
      vim.schedule(function()
        vim.cmd.packadd("nvim-treesitter")
        vim.cmd("TSUpdate")
      end)
    end
  end,
})

-- Make all dependencies available before executing any plugin scripts.
vim.pack.add(specs, { load = false })
for _, spec in ipairs(specs) do
  vim.cmd.packadd(spec.name)
end

-- Setup order is explicit; all plugins load during startup.
local configs = {
  "whichkey", "themes", "mini", "screenkey", "fidget", "telescope",
  "luasnip", "completion", "treesitter", "lsp", "debug", "toggleterm",
  "nvim-tree", "lualine", "conform", "colorizer", "rainbowdels",
  "flash", "yazi", "zen", "treesj", "hardtime", "comments", "chatgpt",
}
for _, name in ipairs(configs) do
  require("plugins." .. name)()
end
