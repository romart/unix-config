return {
  {
    'akinsho/toggleterm.nvim',
    opts = {},
    config = function()
      local tgl = require("toggleterm")
      tgl.setup {
        direction = "float",
        on_create = function(term)
          local opts = { buffer = term.bufnr }
          vim.keymap.set('t', '<C-t>', function() term:toggle() end, opts)
          vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
          vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
          vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
          vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
          vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        end
      }
      local start_new_term = function()
        local name = vim.fn.input("Enter Terminal name: ")
        vim.cmd("TermNew direction=float name=\"" .. name .. "\"")
      end
      local wk = require("which-key")
      local telutil = require("utils.telescope")
      local themes = require("telescope.themes")

      wk.add({
        { "<C-t>",    ":ToggleTerm direction=float<CR>",                                                       desc = "Toggle default floating terminal",              mode = { "n" } },
        { "<A-t>",    start_new_term,                                                                          desc = "Create New terminal",                           mode = "n" },
        { "<space>c", function() telutil.send_selection_to_term("single_line", themes.get_cursor {}) end,      desc = "Send current line into selected terminal",      mode = "n" },
        { "<space>c", function() telutil.send_selection_to_term("visual_lines", themes.get_cursor {}) end,     desc = "Send selected lines into selected terminal",    mode = "x" },
        { "<space>c", function() telutil.send_selection_to_term("visual_selection", themes.get_cursor {}) end, desc = "Send current selection into selected terminal", mode = "v" },
      })
    end
  },
  {
    "ryanmsnyder/toggleterm-manager.nvim",
    dependencies = {
      "akinsho/nvim-toggleterm.lua",
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- only needed because it's a dependency of telescope
    },
    config = function()
      local toggleterm_manager = require("toggleterm-manager")
      local actions = toggleterm_manager.actions

      toggleterm_manager.setup {

        titles = {
          prompt = "Pick Terminal",
          results = "Terminals"
        },

        mappings = {
          i = {
            ["<CR>"] = { action = actions.toggle_term, exit_on_action = true },
            ["<C-i>"] = { action = actions.create_and_name_term, exit_on_action = false },
            ["<C-r>"] = { action = actions.rename_term, exit_on_action = false },
            ["<C-d>"] = { action = actions.delete_term, exit_on_action = false },
          },
        },
      }
    end,
  }
}
