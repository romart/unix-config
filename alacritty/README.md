# Prerequisites

## Shift+Enter

Shift+Enter sends `ESC [ 13 ; 2 u` (CSI u), distinct from ordinary Enter.
The zsh config binds this to inserting a newline without executing the buffer.
The shared tmux config preserves extended keys in CSI u format (tmux 3.3+).
Other applications must support or bind Shift+Enter themselves.

Open a new Alacritty window and a new shell after updating. In an existing
tmux server, reload with `tmux source-file ~/.tmux.conf`.
Test at the zsh prompt: type `echo first`, press Shift+Enter, then type
`echo second`. Neither command should run until you press regular Enter.
Repeat inside tmux.

Alacritty chooses its own `TERM`; tmux sets `tmux-256color` inside panes.
Remote hosts need terminfo for the terminal type used when connecting.

## Nerd fonts

Install any nerd font to enable glyphs, i.e. space-mono-nerd

```shell
pacman -S ttf-space-mono-nerd
```

# Build Alacritty

Follow instruction https://github.com/alacritty/alacritty/blob/master/INSTALL.md

# Set Config

```shell
ln -s $REPO/alacritty $HOME/.config/alacritty
```

# Install themes

```shell
git clone https://github.com/alacritty/alacritty-theme.git $HOME/.config/alacritty/themes
```

## Install iterm2 color schemes

https://github.com/mbadolato/iTerm2-Color-Schemes/releases

Download release tar archive

```shell
tar xvf alacritty-themes.tgz -C $HOME/.config/alacritty/themes/themes/
```
