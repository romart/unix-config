return {

  "folke/zen-mode.nvim",

  config = function()
    local zen = require("zen-mode")
    local wk = require("which-key")
    zen.setup {}

    wk.add({
      { "<leader>z",  group = "Zen" },
      { "<leader>zz", ":ZenMode<CR>", desc = "Enter/Exit" }
    })
  end
}
