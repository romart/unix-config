# Neovim configuration

This configuration requires Neovim 0.12 or newer and uses Neovim's built-in
`vim.pack` plugin manager.

## Requirements

Install the base tools:

```sh
# Arch Linux
sudo pacman -S neovim git base-devel cmake
```

The configuration also expects these external programs, depending on which
features you use:

- `yazi` for the Yazi file manager
- `rg` for Telescope file search
- `fzf` for some Telescope workflows
- `make` and a C compiler for native LuaSnip support
- language servers and formatters managed by Mason or installed separately
- `hyprctl`, `brightnessctl`, and related tools only for Hyprland integration

## Installation

Link this directory to Neovim's configuration path:

```sh
ln -s "$GIT_REPO/nvim" "$HOME/.config/nvim"
```

Start Neovim normally:

```sh
nvim
```

On the first start, `vim.pack` reads `nvim-pack-lock.json`, installs the pinned
plugins, and loads them. Confirm the installation prompt if one appears.
Native extensions are built automatically for LuaSnip and Telescope. Treesitter
may download and compile the configured parsers on the first start.

The lockfile is part of this repository and should be committed with the
configuration. Do not edit it by hand.

## Plugin management

Update plugins from inside Neovim:

```vim
:lua vim.pack.update()
```

Review the proposed changes, then press `:write` to accept them or `:quit` to
discard them. Restart Neovim after accepting updates.

Inspect installed plugins with:

```vim
:lua vim.print(vim.pack.get())
```

Check the Yazi integration with:

```vim
:checkhealth yazi
```

The old `lazy.nvim` manager is no longer required.
