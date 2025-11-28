# Prerequisites

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

