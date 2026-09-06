return function()
  -- folke/which-key.nvim
  do
    local opts = {
      -- preset = "helix",
      plugins = {
        marks = false,
        operators = false,
        windows = false,
        nav = false,
      },
      win = {
        padding = { 0, 1 },
        title = false,
        border = "none",
      },
      icons = {
        breadcrumb = ">>=",
        separator = ":: ",
        group = " ++ ",
        keys = {},
      },
    }
    local wk = require("which-key")
    wk.setup(opts)
    wk.add({
      { "<leader>?", function() wk.show({ global = false }) end, desc = "Buffer Local Keymaps (which-key)", mode = "n" },
    })
  end
end
