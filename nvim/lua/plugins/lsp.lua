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
          -- "cl-lsp"
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

      local configure_clangd = function(cmd_json_file)
        local tempdir = vim.fn.tempname()
        vim.fn.mkdir(tempdir, "p")
        local db_abs_path = vim.fn.fnamemodify(cmd_json_file, ":p")
        local db_target_path = tempdir .. '/' .. 'compile_commands.json'
        vim.loop.fs_symlink(db_abs_path, db_target_path, { dir = false })
        print("Configure clangd with " .. db_abs_path .. ' -> ' .. db_target_path)

        vim.api.nvim_create_autocmd("VimLeavePre", {
          once = true,
          callback = function()
            vim.loop.fs_unlink(db_target_path)
            vim.loop.fs_rmdir(tempdir)
          end,
        })

        lspconfig.clangd.setup {
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
            "--compile-commands-dir=" .. tempdir,
            "--limit-results=0"
          },
          init_option = {
            fallbackFlags = { "-std=c++2a" },
            clangdFileStatus = true,
          },
          capabilities = capabilities,
          single_file_support = true,
        }
        -- vim.cmd("LspStart clangd")
      end

      vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        callback = function()
          local files = vim.fn.readdir(".")
          local json_files = vim.tbl_filter(function(fname)
            return fname:match("^compile_commands.*%.json$")
          end, files)
          if #json_files == 0 then
            -- TODO: not sure if this is desired behaviour
            -- configure_clangd("compile_commands.json")
            return
          elseif #json_files == 1 then
            configure_clangd(json_files[1])
          else
            vim.ui.select(json_files, {
              prompt = "Select compile command file to use for clangd",
            }, function(value, _)
              configure_clangd(value)
            end
            )
          end
        end
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

      -- No LISP LSP :(
      -- if not lspconfig.cl_lsp then
      --   lspconfig.cl_lsp = {
      --     default_config = {
      --       cmd = { vim.env.HOME .. "/.roswell/bin/cl-lsp"},
      --       filetypes = {'lisp', "scm"},
      --       root_dir = function (startpath)
      --         return vim.fs.dirname(vim.fs.find('.git', { path = startpath, upward = true })[1])
      --       end,
      --       settings = {},
      --     },
      --   }
      -- end
      --
      -- lspconfig.cl_lsp.setup {}

      local wk = require("which-key")
      wk.add
      {
        { "gd", vim.lsp.buf.definition,  desc = "Goto Definition",  mode = "n" },
        { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration", mode = "n" },
        -- { "<Enter>", vim.lsp.buf.code_action, desc = "Code Action", mode = "i" },
      }
    end
  },
}
