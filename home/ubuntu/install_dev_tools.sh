#!/bin/bash

curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install git curl wget python3-pip tmux nodejs -y
sudo chown ubuntu -R ~/.config
sudo chmod u+rwx ~/.config

sudo mkdir -p ~/.config/nvim

# Setup neovim
pushd /tmp
wget --quiet https://github.com/neovim/neovim/releases/download/v0.7.0/nvim-linux64.deb
wget --quiet https://github.com/neovim/neovim/releases/download/v0.7.0/nvim-linux64.deb.sha256sum

if ! sha256sum -c nvim-linux64.deb.sha256sum; then
	echo "Checksum failed" >& 2
	exit 1
fi
popd

sudo apt install "/tmp/nvim-linux64.deb"

wget --quiet https://gist.githubusercontent.com/ArvinSKushwaha/14b6ed416947ec044abf706fa89cb904/raw/4045753f2b8fdc108baf4400d35ca154ef54210b/init.vim

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

sudo mv init.vim ~/.config/nvim/init.vim --backup=none

pip3 install --user neovim
nvim --headless +PlugInstall +qa
