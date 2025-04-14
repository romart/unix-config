return {
  'nvim-tree/nvim-tree.lua',

  dependencies = {
    "nvim-tree/nvim-web-devicons",
    opts = {}
  },

  config = function()
    require('nvim-tree').setup({
      filters = { dotfiles = false, git_ignored = false },
      auto_reload_on_write = true,
      view = {
        centralize_selection = false,
        cursorline = true,
        debounce_delay = 15,
        width = {},
        side = "left",
        preserve_window_proportions = false,
        number = true,
        relativenumber = true,
        signcolumn = "yes",
      },
      update_focused_file = { enable = true, update_root = false, ignore_list = {} },
      renderer = {
        add_trailing = false,
        group_empty = false,
        highlight_git = false,
        full_name = false,
        highlight_opened_files = "all",
        highlight_modified = "none",
        root_folder_label = ":~:s?$?/..?",
        indent_width = 2,
        indent_markers = {
          enable = true,
          inline_arrows = true,
          icons = {
            corner = "└",
            edge = "│",
            item = "│",
            bottom = "─",
            none = " ",
          },
        },
      }
    })
    require("which-key").add {
      { "<C-n>", ":NvimTreeToggle<CR>", desc = "Tree Toggle", mode = { "i", "n" } },
    }
  end
}
