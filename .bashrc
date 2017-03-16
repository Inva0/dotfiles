if [ "$SSH_TTY" ]
then
	date=`date`
	load=`cat /proc/loadavg | awk '{print $1}'`
	root_usage=`df -h / | awk '/\// {print $(NF-1)}'`
	memory_usage=`free -m | awk '/Mem/ { printf("%3.1f%%", $3/$2*100) }'`
	swap_usage=`free -m | awk '/Swap/ { printf("%3.1f%%", $3/$2*100) }'`
	users=`users | wc -w`

	echo "System information as of: $date"
	echo
	printf "System load:\t%s\tMemory usage:\t%s\n" $load $memory_usage
	printf "Usage on /:\t%s\tSwap usage:\t%s\n" $root_usage $swap_usage
	printf "Local users:\t%s\n" $users
	echo
	echo -e `cat ~/.todo`
fi

#setting up git bash prompt
if [ -f  ~/.git-prompt.sh ]; then
. /etc/bash_completion
fi

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '

#PS1='\u@\h:\w$(__git_ps1) \$ '

PS1='\t \[\e[0;33m\]\u@\h\[\e[m\]:\[\e[00;36m\][\w]$(__git_ps1)\[\e[0m\]\[\e[00;37m\]\[\e[0m\]\$\[\e[m\] \[\e[0;37m\]'
# umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
# export LS_OPTIONS='--color=auto'
# eval "`dircolors`"
eval "`dircolors -b ~/.dir_colors`"


# history control !
export HISTCONTROL=ignoreboth:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000


# Some more alias to avoid making mistakes:
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
#ccat with color
alias ccat='pygmentize'

# LS cmd
alias ls='ls --color=auto'
alias la='ls -ah'
alias ll='ls -lah'

#CD shortcut
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'

#clear shortcut
alias c='clear'

# GREP Styling
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

#Mkdir auto parents & verbose
alias mkdir='mkdir -pv'

#Human readable
alias du='du -kh'
alias df='df -kTh'

#Reload BashRc
alias bashrc='. ~/.bashrc'

#Public ip adress
alias myip="curl http://ipecho.net/plain; echo"

#apt aliases
alias update='sudo apt-get update && sudo apt-get upgrade'
alias clean='sudo apt-get autoclean && sudo apt-get autoremove && sudo apt-get clean'

# Set coloration capabilities for term
export TERM='xterm-256color'

#launch tmux in UTF8 mode (for putty)
alias tmux="TERM=screen-256color tmux -u"

#Extracting function
function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
 else
    if [ -f $1 ] ; then
        # NAME=${1%.*}
        # mkdir $NAME && cd $NAME
        case $1 in
          *.tar.bz2)   tar xvjf ../$1    ;;
          *.tar.gz)    tar xvzf ../$1    ;;
          *.tar.xz)    tar xvJf ../$1    ;;
          *.lzma)      unlzma ../$1      ;;
          *.bz2)       bunzip2 ../$1     ;;
          *.rar)       unrar x -ad ../$1 ;;
          *.gz)        gunzip ../$1      ;;
          *.tar)       tar xvf ../$1     ;;
          *.tbz2)      tar xvjf ../$1    ;;
          *.tgz)       tar xvzf ../$1    ;;
          *.zip)       unzip ../$1       ;;
          *.Z)         uncompress ../$1  ;;
          *.7z)        7z x ../$1        ;;
          *.xz)        unxz ../$1        ;;
          *.exe)       cabextract ../$1  ;;
          *)           echo "extract: '$1' - unknown archive method" ;;
        esac
    else
        echo "$1 - file does not exist"
    fi
fi
}

function mkcd(){
    mkdir -p -- "$1" && cd -P -- "$1"
}

#MODIFY PATH
export PATH=$PATH:/opt/node-v5.1.1-linux-x64/bin/

#SET ENV VAR
export EDITOR='vim'

#PATH FOR GOLANG
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
