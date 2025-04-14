return {
  "L3MON4D3/LuaSnip",
  dependencies = {
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",
    "onsails/lspkind.nvim",
  },
  config = function()
    local luasnip = require("luasnip")
    local wk = require("which-key")

    luasnip.add_snippets("c", require("snippets.cpp"))
    luasnip.add_snippets("cpp", require("snippets.cpp"))
    luasnip.add_snippets("tex", require("snippets.tex"))

    require("luasnip.loaders.from_vscode").lazy_load()

    wk.add {
      { "<C-K>", luasnip.expand,                  mode = "i",          silent = true, desc = "Expand Snippet" },
      { "<C-L>", function() luasnip.jump(1) end,  mode = { "i", "s" }, silent = true, desc = "Jump Forward" },
      { "<C-J>", function() luasnip.jump(-1) end, mode = { "i", "s" }, silent = true, desc = "Jump Backward" },
      {
        "<C-E>",
        function()
          if luasnip.choice_active() then
            luasnip.change_choice(1)
          end
        end,
        mode = { "i", "s" },
        silent = true,
        desc = "Change active choice"
      },
    }
  end
}
