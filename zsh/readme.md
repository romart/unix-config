## Zsh setup

### Prerequsieted

1. Setup required libraries

1.1. FZF

```shell
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

1.2. OhMyZsh

```shell
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
```

1.3. Virtualenv

```shell
pip install virtualenvwrapper
```

2. Link zsh config

```shell
ln -s $REPO/zsh $HOME/.config/zsh
ln -s $HOME/.config/zsh/zshrc $HOME/.zshrc
```

3. Enable Zsh

```shell
sudo chsh -s $(which zsh) $USER
```
