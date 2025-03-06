## VIM Config setup

This config depends on plugin manager which could be set up
`curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim`

It also requires vim build with Lua support.

To install plugins run vim command `PlugInstall`

For C/C++ code highlighring and insights plugin `YouCompleteMe` is used which requires clangd server.
To start it run
```bash
cd ~/.vim/plugged/YouCompleteMe
python3 install.py --clangd-completer
```

To debug code use `vim.spector` which config file could be for C++
```json
{
    "configurations": {
        "C++ Debug": {
            "adapter": "vscode-cpptools",
            "configuration": {
                "request": "launch",
                "program": "${workspaceRoot}/build/bin/main",
                "args": ["aaa", "bbbb"],
                "stopAtEntry": false,
                "cwd": "${workspaceRoot}",
                "environment": [],
                "externalConsole": false,
                "MIMode": "gdb",
                "miDebuggerPath": "/usr/bin/gdb"
            }
        }
    }
}
```

or Python version
```json
{
  "configurations": {
    "Python: Launch": {
      "adapter": "debugpy",
      "configuration": {
        "request": "launch",
        "type": "python",
        "program": "${file}",
        "console": "integratedTerminal",
        "cwd": "${workspaceRoot}",
        "args": ["aaa", "bbbb"],
        "justMyCode": true
      }
    }
  }
}
```
