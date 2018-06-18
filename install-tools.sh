#!/bin/bash
#install-tools.sh

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

install_basic
install_z
install_pwngdb
