return {

  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        PATH = "prepend",
      })
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
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
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      local configs = require("lspconfig.configs")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local utils = require('utils')

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

      local wk = require("which-key")
      wk.add
      {
        { "gd", vim.lsp.buf.definition,  desc = "Goto Definition",  mode = "n" },
        { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration", mode = "n" },
      }
    end
  },
}
