return {

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lsp-signature-help" },
      { "kdheepak/cmp-latex-symbols" },
      {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
          require("nvim-autopairs").setup {
            disable_filetype = { "TelescopePrompt", "vim" },
            fast_wrap = {
              map = '<M-e>',
              chars = { '{', '[', '(', '"', "'" },
              pattern = [=[[%'%"%>%]%)%}%,]]=],
              end_key = '$',
              before_key = 'h',
              after_key = 'l',
              cursor_pos_before = true,
              keys = 'qwertyuiopzxcvbnmasdfghjkl',
              manual_position = true,
              highlight = 'Search',
              highlight_grey = 'Comment',
              check_ts = true
            },
          }
        end
      },
      {
        "L3MON4D3/LuaSnip"
      }
    },
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      local luasnip = require("luasnip")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")

      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      cmp.setup {
        preselect = cmp.PreselectMode.None,
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = { border = "solid" },
          documentation = { border = "solid" },
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          -- ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<CR>"] = cmp.mapping.confirm({ select = false }),

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },                 -- For luasnip users.
          { name = "nvim_lsp_signature_help" }, -- function arg popups while typing
        }, {
          { name = "buffer" },
          { name = "latex_symbols" },
        }),
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            local kind_icons = {
              Function = "λ", -- Lambda symbol for functions
              Method = "∂", -- Lambda symbol for methods
              Field = "󰀫", -- Lambda symbol for methods
              Property = "󰀫", -- Lambda symbol for methods
              Keyword = "k", -- Lambda symbol for methods
              Struct = "π", -- Lambda symbol for methods
              Struct = "Π", -- Lambda symbol for methods
              Enum = "τ", -- Lambda symbol for methods
              EnumMember = "τ", -- Lambda symbol for methods
              Snippet = "⊂",
              Text = "τ",
              Module = "⌠",
            }

            local kind = lspkind.cmp_format({
              mode = "symbol_text",

              symbol_map = kind_icons, -- Override default symbols
            })(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. (strings[1] or "") .. " "
            kind.menu = "    " .. (strings[2] or "") .. ""

            return kind
          end
        }
      }
    end
  },
}
