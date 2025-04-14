return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local utils = require('utils')

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
    end
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio"
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      dapui.setup {}

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

      local function terminate_debug()
        dap.terminate()
        dapui.close()
      end

      local wk = require("which-key")
      wk.add(
        {
          { "<F5>",      dap.continue,          desc = "Continue Execution", mode = "n" },
          { "<F9>",      dap.toggle_breakpoint, desc = "Toggle Breakpoint",  mode = "n" },
          { "<F8>",      dap.step_over,         desc = "Step Over",          mode = "n" },
          { "<F10>",     dap.step_into,         desc = "Step Into",          mode = "n" },
          { "<F11>",     dap.step_out,          desc = "Step Out",           mode = "n" },
          { "<F12>",     terminate_debug,       desc = "Terminate",          mode = "n" },
          { "<leader>P", dap.pause,             desc = "Pause",              mode = "n" },
        }
      )
    end
  },
}
