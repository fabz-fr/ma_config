#!/bin/bash

# Install tools
# xclip is mandatory to allow copy from nvim to clipboard
sudo apt install -y xclip

# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Install wezterm.lua in ~/
ln -s wezterm/.wezterm.lua ~/.wezterm.lua

# Install nvim config
ln -s nvim/ ~/.config/nvim

# install .gitconfig in ~/.gitconfig
ln -s git/.gitconfig ~/.gitconfig

# Install yazi config in ~/.config/yazi/
ln -s yazi ~/.config/yazi


