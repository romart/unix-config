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

      vim.lsp.config('sqlls', {
        capabilities = capabilities,
      })

      vim.lsp.config('texlab', {
        capabilities = capabilities,
      })

      vim.lsp.config('hls', {
        capabilities = capabilities,
        single_file_support = true,
      })

      vim.lsp.config('bashls', {
        capabilities = capabilities,
      })

      vim.lsp.config('lua_ls', {
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

      vim.lsp.config('jsonls', {
        capabilities = capabilities,
      })

      vim.lsp.config('cssls', {
        capabilities = capabilities,
      })

      vim.lsp.config('yamlls', {
        capabilities = capabilities,
      })

      vim.lsp.config('html', {
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
        if not cmd_json_file then return end
        local db_abs_path = vim.fn.fnamemodify(cmd_json_file, ":p")
        local uv = vim.uv or vim.loop
        local stat = uv.fs_stat(db_abs_path)
        if not stat or stat.type ~= "file" then
          vim.notify("Compilation database is not a file: " .. db_abs_path, vim.log.levels.ERROR)
          return
        end
        local db_dir = vim.fn.fnamemodify(db_abs_path, ":h")
        if vim.fn.fnamemodify(db_abs_path, ":t") ~= "compile_commands.json" then
          local temp_dir, err = uv.fs_mkdtemp(vim.fn.tempname() .. "-XXXXXX")
          if not temp_dir then
            vim.notify("Cannot create database directory: " .. tostring(err), vim.log.levels.ERROR)
            return
          end
          local link = temp_dir .. "/compile_commands.json"
          local linked, link_err = uv.fs_symlink(db_abs_path, link)
          if not linked then
            uv.fs_rmdir(temp_dir)
            vim.notify("Cannot link database: " .. tostring(link_err), vim.log.levels.ERROR)
            return
          end
          db_dir = temp_dir
          vim.api.nvim_create_autocmd("VimLeavePre", {
            once = true,
            callback = function()
              if uv.fs_readlink(link) == db_abs_path then
                uv.fs_unlink(link)
              end
              uv.fs_rmdir(temp_dir)
            end,
          })
        end

        vim.lsp.config('clangd', {
          cmd = {
            "clangd",
            "--compile-commands-dir=" .. db_dir,
            "--background-index",
            "--pch-storage=memory",
            "--all-scopes-completion",
            "--pretty",
            "--header-insertion=never",
            "-j=2",
            "--header-insertion-decorators",
            "--function-arg-placeholders=false",
            "--completion-style=detailed",
            "--limit-results=0"
          },
          init_options = {
            fallbackFlags = { "-std=c++2a" },
            clangdFileStatus = true,
          },
          capabilities = capabilities,
          single_file_support = true,
        })
        -- vim.cmd("LspStart clangd")
      end

      if not utils.is_git_commit() then
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
      end

      vim.lsp.config('pylsp', {
        capabilities = capabilities,
        settings = {
          python = {
            pythonPath = utils.get_python_path(),
          },
        },
      })

      vim.lsp.config('marksman', {
        capabilities = capabilities,
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
        { "gC", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" } },
      }
    end
  },
}
