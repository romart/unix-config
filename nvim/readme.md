## Neovim setup

### Prerequsieted

1. Setup required libraries

```shell
sudo apt install ripgrep fd-find luarocks npm
sudo npm install -g tree-sitter-cli
```

2. Build yazi tool

Follow the [instruction](https://yazi-rs.github.io/docs/installation/#source)

3. Setup vscode cpp tools

3.1 Download last release [cpptools-alpine-x64.vsix](https://github.com/microsoft/vscode-cpptools/releases)
3.2 Setup
```shell
unzip  cpptools-alpine-x64.vsix -d $HOME/cpptools
chmod +x $HOME/cpptools/extension/debugAdapters/bin/OpenDebugAD7
```

### Build neovim

https://github.com/neovim/neovim/blob/master/INSTALL.md#install-from-source


### Setup

```shell
ln -s $REPO/nvim $HOME/.config/nvim
```

