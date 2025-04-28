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
      local utils = require("utils")

      local function find_files(text)
        builtin.find_files({
          find_command = { 'rg', '--files', '--hidden', '-g', '!.git' },
          search_file = text
        })
      end

      local function vmode_wrapper(func, q)
        local mode = vim.fn.mode()
        if mode ~= 'v' and mode ~= 'V' then
          return
        end

        local selected = utils.get_visual_selected(true)
        -- vim.notify("WRAPPER: Selected text: '" .. selected .. "'")
        local options = {}
        options[q] = selected
        func(options)
      end

      local function show_buffers()
        builtin.buffers({
          ignore_current_buffer = true,
          sort_mru = true,
        })
      end
      local function show_diagnostics()
        builtin.diagnostics(({
          line_width = 90,
          bufnr = 0,
        }))
      end
      local function current_buf_fzf()
        builtin.current_buffer_fuzzy_find({
          skip_empty_lines = true
        })
      end

      wk.add {
        { "<leader>",   group = "Telescope" },
        { "<leader>B",  show_buffers,                        desc = "Open Buffers",                      mode = "n" },
        { "<leader>H",  builtin.command_history,             desc = "Command History",                   mode = "n" },
        { "<leader>M",  builtin.marks,                       desc = "Marks",                             mode = "n" },
        { "<leader>R",  builtin.registers,                   desc = "Registers",                         mode = "n" },
        { "<leader>J",  builtin.jumplist,                    desc = "Jump List",                         mode = "n" },
        { "<leader>S",  builtin.search_history,              desc = "Search History",                    mode = "n" },
        { "<leader>F",  find_files,                          desc = "Find Files",                        mode = "n" },
        { "<leader>T",  ":Telescope toggleterm_manager<CR>", desc = "List Open Terminals",               mode = "n" },
        { "<leader>ds", builtin.lsp_document_symbols,        desc = "Current Buffer Symbols",            mode = "n" },
        { "<leader>gs", builtin.grep_string,                 desc = "Grep string (udnder cursor)",       mode = "n" },
        { "<leader>ww", builtin.treesitter,                  desc = "Function names, variables",         mode = "n" },
        { "<leader>fr", builtin.lsp_references,              desc = "Symbol (under cursor) references",  mode = "n" },
        { "<leader>fd", show_diagnostics,                    desc = "Diagnostics",                       mode = "n" },
        { "<leader>ff", current_buf_fzf,                     desc = "FZF Current Buffer",                mode = "n" },
        { "<leader>fg", builtin.live_grep,                   desc = "Live Grep",                         mode = "n" },
        { "<leader>fv", builtin.help_tags,                   desc = "Help Tags",                         mode = "n" },
        { "<leader>ws", builtin.lsp_workspace_symbols,       desc = "Workspace Symbols",                 mode = "n" },
        { "<leader>t",  builtin.resume,                      desc = "Resume Previous Telescope session", mode = { "n", "v" } },

      }
      wk.add {
        { "<leader>",   group = "Telescope" },
        { "<leader>gs", function() vmode_wrapper(builtin.grep_string, "search") end,          desc = "Grep string (udnder cursor)", mode = "v" },
        { "<leader>ws", function() vmode_wrapper(builtin.lsp_workspace_symbols, "query") end, desc = "Workspace Symbols",           mode = "v" },
      }
    end
  },
}
