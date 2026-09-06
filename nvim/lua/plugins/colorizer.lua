return function()
  -- norcalli/nvim-colorizer.lua
  do
    require("colorizer").setup {
      "*",
      css = { rgb_fn = true },
    }
  end
end
