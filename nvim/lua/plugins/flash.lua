return {
  "folke/flash.nvim",
  event = "VeryLazy",
  config = function()
    local flash = require("flash")
    local wk = require("which-key")
    flash.setup {}

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
  end
}
