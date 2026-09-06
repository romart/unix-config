return function()
  -- nvim-treesitter/nvim-treesitter
  local treesitter = require("nvim-treesitter")
  local languages = {
    "nix", "vimdoc", "c", "cpp", "commonlisp", "java", "kotlin",
    "blueprint", "bash", "lua", "python", "html", "css", "javascript",
    "typescript", "haskell", "sql", "scheme", "markdown", "latex",
    "vim", "toml", "yaml",
  }

  treesitter.setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
  })
  treesitter.install(languages)

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function(args)
      pcall(vim.treesitter.start, args.buf)
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  })
end
