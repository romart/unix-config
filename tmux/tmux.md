## Setup

```shell
mkdir -p $HOME/.config/tmux
ln -s $GIT_REPO/tmux/common.tmux.conf $HOME/.config/tmux/common.tmux.conf
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
## Plugin install

To install plugins start tmux and run

```shell
prefix + I
```
