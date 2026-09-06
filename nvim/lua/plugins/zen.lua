return function()
  -- folke/zen-mode.nvim
  do
    local zen = require("zen-mode")
    local wk = require("which-key")
    zen.setup {}

    wk.add({
      { "<leader>z",  group = "Zen" },
      { "<leader>zz", ":ZenMode<CR>", desc = "Enter/Exit" }
    })
  end
end
