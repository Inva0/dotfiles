#!/bin/bash
DOTFILES_DIR="$HOME/dotfiles"
INSTALL_DIR="$HOME/install"

echo "installing dotfiles for user : $USER"

read -p "Continue? [Y/n]" -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Cancelling"
    exit 1
fi

ln -sf $DOTFILES_DIR/.tmux.conf ~/.tmux.conf
ln -sf $DOTFILES_DIR/.vimrc ~/.vimrc
ln -sf $DOTFILES_DIR/.gitconfig ~/.gitconfig
ln -sf $DOTFILES_DIR/.gdbinit ~/.gdbinit
ln -sf $DOTFILES_DIR/.dir_colors ~/.dir_colors
ln -sf $DOTFILES_DIR/.bashrc ~/.bashrc
ln -sf $DOTFILES_DIR/.dockerfunc ~/.dockerfunc
ln -sf $DOTFILES_DIR/.config/ ~/

./install-tools.sh

echo "now you should execute the next command to reload your config"
echo
echo ". ~/.bashrc"
echo

