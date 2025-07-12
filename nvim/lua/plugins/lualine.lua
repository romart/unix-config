return {

  "nvim-lualine/lualine.nvim",

  dependencies = { "echasnovski/mini.icons" },
  config = function()
    sk = require("screenkey")
    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = "::",
        section_separators = "",
      },

      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          function()
            local bufnr = vim.api.nvim_get_current_buf()
            local fullpath = vim.api.nvim_buf_get_name(bufnr)
            local filename = vim.fn.fnamemodify(fullpath, ":t")
            local keys = sk.get_keys()
            if keys and keys ~= "" then
              keys = " | " .. keys
            end
            return " " .. bufnr .. " " .. filename .. keys
          end
        },
        lualine_x = {
          {
            'encoding',
            -- Show '[BOM]' when the file has a byte-order mark
            -- show_bomb = true,
          },
          {
            'fileformat',
            symbols = {
              unix = '', -- e712
              dos = '', -- e70f
              mac = '', -- e711
            }
          },
          {
            'filetype',
            colored = true,            -- Displays filetype icon in color if set to true
            icon_only = false,         -- Display only an icon for filetype
            icon = { align = 'left' }, -- Display filetype icon on the right hand side
            -- icon =    {'X', align='right'}
            -- Icon string ^ in table is ignored in filetype component
          }
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    })
  end
}
