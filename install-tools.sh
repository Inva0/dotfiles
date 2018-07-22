#!/bin/bash
#install-tools.sh

DOTFILES_DIR="$HOME/dotfiles"

# TOFIX : better usage of "bin" vs "src"
INSTALL_DIR="/usr/local/bin"
SOURCE_DIR="/usr/local/src"

echo "Do you want to install tools ?"
read -p "Continue? [Y/n]" -n 1 -r

echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Abort!"
    exit 1
fi


install_terminator(){
	sudo apt install -y terminator
}

install_virtualenvwrapper(){
	pip install virtualenvwrapper
}

install_basic(){
    echo "Installing basic tools"
    sudo apt update && sudo apt install -y vim nano tmux screen tree gawk git htop build-essential curl
}

install_z(){
    echo "Installing z"
    cd $INSTALL_DIR
    sudo git clone https://github.com/rupa/z
}
 
install_pwngdb(){
    echo "Installing pwndbg"

	#ensure gdb is present
	sudo apt install -y gdb 
	cd $INSTALL_DIR
    sudo git clone https://github.com/pwndbg/pwndbg
    cd pwndbg
    ./setup.sh
}

install_i3(){
	echo "Installing i3"
	sudo apt install -y i3 i3blocks
	sudo ln -sf $DOTFILES_DIR/i3blocks.conf /etc/i3blocks.conf
}

install_go(){
	GOVERSION="1.10.3"
	GOOS=$(uname -s)
	GOARCH="amd64"
	
	mkdir -p $HOME/go/bin $HOME/go/src $HOME/go/pkg

	cd $INSTALL_DIR
	sudo wget https://dl.google.com/go/go$GOVERSION.$GOOS-$GOARCH.tar.gz
	sudo tar -C /usr/local -xzf go$GOVERSION.$GOOS-$GOARCH.tar.gz

	#Install dep 
	# blabla I know the pipe sh thing.
	curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

}
install_neofetch(){
	sudo apt install -y neofetch
}

install_feh(){
	sudo apt install -y feh
}

install_docker(){
	#blabla know what you'r doing
	cd $INSTALL_DIR
	curl -fsSL get.docker.com -o get-docker.sh
	sudo sh get-docker.sh
}

install_gestures(){
	sudo apt install -y libinput-tools
	cd $INSTALL_DIR
	sudo git clone https://github.com/bulletmark/libinput-gestures.git
	cd libinput-gestures
	sudo make install
}

install_graphical_env(){
	install_i3
	install_terminator
	install_feh
	install_neofetch
	install_gestures
}

install_rkhunter(){
	sudo apt install -y rkhunter
	rkhunter --update
	sudo cp $DOTFILES_DIR/rkhunter/rkhunter.service /etc/systemd/system/
	sudo cp $DOTFILES_DIR/rkhunter/rkhunter.timer /etc/systemd/system/
}

install_fail2ban(){
	sudo apt install -y fail2ban
	sudo cp $DOTFILES_DIR/fail2ban/rules.conf /etc/fail2ban/jail.d/rules.conf
	sudo fail2ban-client start	
	sudo fail2ban-client reload
}

install_firewall(){
	sudo apt install -y ufw
	sudo ufw enable
	# better explicit than implicit
	sudo ufw default deny incoming
	sudo ufw default allow outgoing
	sudo ufw logging on 
}

hardening(){
	install_firewall
	install_rkhunter
	install_fail2ban	
}

install_r2(){
	cd $SOURCE_DIR
	git clone https://github.com/radare/radare2
	cd radare2/
	sudo sys/install.sh
	r2pm install r2dec
}

install_infosec(){
	install_r2
	install_pwngdb
}

# just in case, got time to ctrl + c
sleep 3

install_basic
install_docker
install_go
install_z


echo "Do you want to install graphical environment (I3, terminal, gesture, background...)?"
read -p "Continue? [Y/n]" -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Ok"
	install_graphical_env
fi

# this is kinda crappy yep.
echo "Do you want to install infosec tools?"
read -p "Continue? [Y/n]" -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Ok"
	install_infosec
fi

# this is kinda crappy yep.
echo "Do you want to launch the pseudo-hardening of the system ?"
read -p "Continue? [Y/n]" -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Ok"
	hardening
fi

