#!/bin/bash
#install-tools.sh

DOTFILES_DIR="$HOME/dotfiles"
INSTALL_DIR="$HOME/install"

echo "Do you want to install tools ?"
read -p "Continue? [Y/n]" -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Abort!"
    exit 1
fi

install_basic(){
    echo "Installing basic tools"
    sudo apt update && sudo apt install -y vim nano tmux screen tree gawk git htop build-essential
}

install_z(){
    echo "Installing z"
    cd ~/install
    git clone https://github.com/rupa/z
}

install_pwngdb(){
    echo "Installing pwndbg"
    cd ~/install
    git clone https://github.com/pwndbg/pwndbg
    cd pwndbg
    ./setup.sh
}

install_i3(){
   echo "Installing i3"
   sudo apt install i3 i3blocks
   sudo ln -sf $DOTFILES_DIR/i3blocks.conf /etc/i3blocks.conf
}

# just in case, got time to ctrl + c
sleep 3

install_i3
install_basic
install_z
install_pwngdb
