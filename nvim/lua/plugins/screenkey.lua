return function()
  -- NStefan002/screenkey.nvim
  do
    require("screenkey").setup({
      disable = {
        buftypes = { "terminal" },
      },
      group_mappings = true
    })
  end
end
