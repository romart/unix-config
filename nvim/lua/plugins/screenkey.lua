return {
  "NStefan002/screenkey.nvim",
  lazy = false,
  version = "*", -- or branch = "main", to use the latest commit

  config = function()
    require("screenkey").setup({
      disable = {
        buftypes = { "terminal" },
      },
      group_mappings = true
    })
  end
}
