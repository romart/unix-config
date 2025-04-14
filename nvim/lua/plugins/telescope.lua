return {

  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
      },
      {
        "nvim-telescope/telescope-ui-select.nvim"
      },
      {
        "j-hui/fidget.nvim"
      }
    },
    config = function()
      local telescope = require("telescope")

      telescope.load_extension("fzf")
      telescope.load_extension('ui-select')
      telescope.load_extension("fidget")

      telescope.setup({
        extensions = {
          fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({
              -- even more opts
            }),
          }
        },
        pickers = {
          colorscheme = {
            enable_preview = true,
          },
          find_files = {
            hidden = true,
            find_command = {
              "rg",
              "--files",
              "--glob",
              "!{.git/*,.next/*,.svelte-kit/*,target/*,node_modules/*}",
              "--path-separator",
              "/",
            },
          },
        },
      })

      local builtin = require("telescope.builtin")
      local wk = require("which-key")

      local function find_files()
        builtin.find_files({
          find_command = { 'rg', '--files', '--hidden', '-g', '!.git' }
        })
      end

      wk.add {
        { "<leader>",   group = "Telescope" },
        { "<leader>B",  builtin.buffers,                     desc = "Open Buffers" },
        { "<leader>H",  builtin.command_history,             desc = "Command History" },
        { "<leader>M",  builtin.marks,                       desc = "Marks" },
        { "<leader>R",  builtin.registers,                   desc = "Registers" },
        { "<leader>J",  builtin.jumplist,                    desc = "Jump List" },
        { "<leader>S",  builtin.search_history,              desc = "Search History" },
        { "<leader>F",  find_files,                          desc = "Find Files" },
        { "<leader>T",  ":Telescope toggleterm_manager<CR>", desc = "List Open Terminals" },
        { "<leader>ds", builtin.lsp_document_symbols,        desc = "Current Buffer Symbols" },
        { "<leader>gs", builtin.grep_string,                 desc = "Grep string (udnder cursor)" },
        { "<leader>ww", builtin.treesitter,                  desc = "Function names, variables" },
        { "<leader>fr", builtin.lsp_references,              desc = "Symbol (under cursor) references" },
        { "<leader>fd", builtin.diagnostics,                 desc = "Diagnostics" },
        { "<leader>fg", builtin.live_grep,                   desc = "Live Grep" },
        { "<leader>fv", builtin.help_tags,                   desc = "Help Tags" },
        { "<leader>ws", builtin.lsp_workspace_symbols,       desc = "Workspace Symbols" },
      }
    end
  },
}
