local utils = require('utils')

require("colorizer").setup {
  "*",
  css = { rgb_fn = true },
}

require("mason").setup({
  PATH = "prepend",
})

require("mason-lspconfig").setup({
  ensure_installed = {
    "bashls",
    "lua_ls",
    "cmake",
    "html",
    "cssls",
    "tailwindcss",
    "ts_ls",
    "pylsp",
    "clangd",
    "yamlls",
    "jsonls",
    "marksman",
    "sqlls",
    "texlab",
  },
})


local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")

lspconfig.sqlls.setup({
  capabilities = capabilities,
})

lspconfig.texlab.setup({
  capabilities = capabilities,
})

lspconfig.hls.setup({
  capabilities = capabilities,
  single_file_support = true,
})

lspconfig.bashls.setup({
  capabilities = capabilities,
})

lspconfig.lua_ls.setup({
  capabilities = capabilities,
  -- cmd = { "lua_ls" },
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" }, -- Recognize 'vim' as a global variable
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true), -- Include Neovim runtime files
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

lspconfig.jsonls.setup({
  capabilities = capabilities,
})

lspconfig.cssls.setup({
  capabilities = capabilities,
})

lspconfig.yamlls.setup({
  capabilities = capabilities,
})

lspconfig.html.setup({
  capabilities = capabilities,
  filetypes = {
    "templ",
    "html",
    "php",
    "css",
    "javascriptreact",
    "typescriptreact",
    "javascript",
    "typescript",
    "jsx",
    "tsx",
  },
})

lspconfig.clangd.setup({
  cmd = {
    "clangd",
    "--background-index",
    "--pch-storage=memory",
    "--all-scopes-completion",
    "--pretty",
    "--header-insertion=never",
    "-j=2",
    "--inlay-hints",
    "--header-insertion-decorators",
    "--function-arg-placeholders",
    "--completion-style=detailed",
    "--limit-results=0"
  },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_dir = lspconfig.util.root_pattern("src"),
  init_option = {
    fallbackFlags = { "-std=c++2a" },
    clangdFileStatus = true,
    compileCommands = "./compile_commands.json"
  },
  capabilities = capabilities,
  single_file_support = true,
})


lspconfig.pylsp.setup({
  capabilties = capabilities,
  settings = {
    python = {
      pythonPath = utils.get_python_path(),
    },
  },
})

lspconfig.marksman.setup({
  capabilties = capabilities,
})

local cmp = require("cmp")
local lspkind = require("lspkind")
local luasnip = require("luasnip")

luasnip.add_snippets("c", require("snippets.cpp"))
luasnip.add_snippets("cpp", require("snippets.cpp"))
luasnip.add_snippets("tex", require("snippets.tex"))

local cmp_autopairs = require("nvim-autopairs.completion.cmp")

require("luasnip.loaders.from_vscode").lazy_load()

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

cmp.setup {
  preselect = cmp.PreselectMode.None,
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
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



local treesitter = require("nvim-treesitter.configs")
treesitter.setup({
  ensure_installed = {
    "nix",
    "vimdoc",
    "c",
    "cpp",
    "java",
    "kotlin",
    "blueprint",
    "bash",
    "lua",
    "python",
    "html",
    "css",
    "javascript",
    "typescript",
    "haskell",
    "sql",
    "markdown",
    "latex",
  },
  highlight = {
    enable = true,
  },
  indent = { enable = true },
  modules = {},
  sync_install = true,
  auto_install = true,
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<CR>",
      scope_incremental = "<CR>",
      node_incremental = "<TAB>",
      node_decremental = "<S-TAB>",
    },
  },
})


local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    purescript = { "purstidy", stop_after_first = true },
    lua = { "stylua", stop_after_first = true },
    ocaml = { "ocamlformat", stop_after_first = true },
    python = { "black" },
    rust = { "rustfmt" },
    javascript = { "prettier", stop_after_first = true },
    javascriptreact = { "prettier", stop_after_first = true },
    typescript = { "prettier", stop_after_first = true },
    typescriptreact = { "prettier", stop_after_first = true },
    astro = { "astro", stop_after_first = true },
    go = { "gofumpt", "golines", "goimports-reviser" },
    c = { "clang_format" },
    cpp = { "clang_format" },
    haskell = { "ormolu" },
    yaml = { "yamlfmt" },
    html = { "prettier" },
    json = { "prettier" },
    markdown = { "prettier" },
    gleam = { "gleam" },
    asm = { "asmfmt" },
    css = { "prettier", stop_after_first = true },
  },
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat then
      return
    end
    return {
      timeout_ms = 500,
      lsp_format = "fallback",
    }
  end,
})

require('fidget').setup({})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    if vim.g.disable_autoformat then
      return
    end
    conform.format({ bufnr = args.buf })
  end,
})

require("treesj").setup({})
require("nvim-autopairs").setup({})

local telescope = require("telescope")

telescope.load_extension("fzf")
telescope.load_extension('ui-select')
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

require("which-key").setup({
  -- preset = "helix",
  plugins = {
    marks = false,
    operators = false,
    windows = false,
    nav = false,
  },
  win = {
    padding = { 0, 1 },
    title = false,
    border = "none",
  },
  icons = {
    breadcrumb = ">>=",
    separator = ":: ",
    group = " ++ ",
    keys = {},
  },
})

require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = "",
    section_separators = "",
  },

  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = { "filename" },
    lualine_x = {
      function()
        local encoding = vim.o.fileencoding
        if encoding == "" then
          return vim.bo.fileformat .. " :: " .. vim.bo.filetype
        else
          return encoding .. " :: " .. vim.bo.fileformat .. " :: " .. vim.bo.filetype
        end
      end,
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})


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

-- require("vimspector").setup()


local dap, dapui = require("dap"), require("dapui")

dapui.setup({})

dap.set_log_level("DEBUG")

-- dap.adapters.gdb = {
--   type = "executable",
--   command = "gdb",
--   args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
-- }

dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = os.getenv("HOME") .. "/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
}

dap.adapters.python = function(cb, config)
  if config.request == 'attach' then
    ---@diagnostic disable-next-line: undefined-field
    local port = (config.connect or config).port
    ---@diagnostic disable-next-line: undefined-field
    local host = (config.connect or config).host or '127.0.0.1'
    cb({
      type = 'server',
      port = assert(port, '`connect.port` is required for a python `attach` configuration'),
      host = host,
      options = {
        source_filetype = 'python',
      },
    })
  else
    cb({
      type = 'executable',
      command = utils.get_python_path(),
      args = { '-m', 'debugpy.adapter' },
      options = {
        source_filetype = 'python',
      },
    })
  end
end



dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "cppdbg",
    request = "launch",
    program = function()
      local gdbconf = vim.fn.getcwd() .. '/' .. '.dbg.config.json'
      local jsonconf = utils.load_config_from_json(gdbconf)
      return jsonconf.program
    end,
    cwd = '${workspaceFolder}',
    args = function()
      local gdbconf = vim.fn.getcwd() .. '/' .. '.dbg.config.json'
      local jsonconf = utils.load_config_from_json(gdbconf)
      return jsonconf.args
    end,

    environment = function()
      local gdbconf = vim.fn.getcwd() .. '/' .. '.dbg.config.json'
      local jsonconf = utils.load_config_from_json(gdbconf)
      return jsonconf.environment
    end,

    stopAtEntry = true,
  },
  {
    name = 'Attach to gdbserver :1234',
    type = 'cppdbg',
    request = 'launch',
    MIMode = 'gdb',
    miDebuggerServerAddress = 'localhost:1234',
    miDebuggerPath = '/usr/bin/gdb',
    cwd = '${workspaceFolder}',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
  },
}

dap.configurations.c = dap.configurations.cpp

-- dap.configurations.c = {
--   {
--     name = "Launch",
--     type = "gdb",
--     request = "launch",
--     program = function()
--       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--     end,
--     cwd = "${workspaceFolder}",
--     stopAtBeginningOfMainSubprogram = false,
--   },
--   {
--     name = "Select and attach to process",
--     type = "gdb",
--     request = "attach",
--     program = function()
--        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--     end,
--     pid = function()
--        local name = vim.fn.input('Executable name (filter): ')
--        return require("dap.utils").pick_process({ filter = name })
--     end,
--     cwd = '${workspaceFolder}'
--   },
--   {
--     name = 'Attach to gdbserver :1234',
--     type = 'gdb',
--     request = 'attach',
--     target = 'localhost:1234',
--     program = function()
--        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--     end,
--     cwd = '${workspaceFolder}'
--   },
-- }

dap.configurations.python = {
  {
    -- The first three options are required by nvim-dap
    type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = 'launch',
    name = "Launch file",

    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

    program = "${file}", -- This configuration will launch the current file if used.
    pythonPath = utils.get_python_path()
  },
}

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end
