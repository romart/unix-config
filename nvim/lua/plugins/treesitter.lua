return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local treesitter = require("nvim-treesitter.configs")
    treesitter.setup {
      ensure_installed = {
        "nix",
        "vimdoc",
        "c",
        "cpp",
        "commonlisp",
        "java",
        "kotlin",
        "blueprint",
        "bash",
        "lua",
        "python",
        "html",
        "css",
        "javascript",
        "typescript",
        "haskell",
        "sql",
        "scheme",
        "markdown",
        "latex",
      },
      highlight = {
        enable = true,
      },
      indent = { enable = true },
      modules = {},
      sync_install = true,
      auto_install = true,
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>",
          scope_incremental = "<CR>",
          node_incremental = "<TAB>",
          node_decremental = "<S-TAB>",
        },
      },
    }
  end
}
