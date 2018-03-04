cd

date=$(date)
load=$(awk '{print $1}' < /proc/loadavg)
root_usage=$(df -h / | awk '/\// {print $(NF-1)}')
memory_usage=$(free -m | awk '/Mem/ { printf("%3.1f%%", $3/$2*100) }')
swap_usage=$(free -m | awk '/Swap/ { printf("%3.1f%%", $3/$2*100) }')
users=$(users | wc -w)
tmux_sessions=$(tmux ls 2>/dev/null)
tmux_state=$?

echo "System information as of: $date"
echo
printf "System load:\t%s\tMemory usage:\t%s\n" $load $memory_usage
printf "Usage on /:\t%s\tSwap usage:\t%s\n" $root_usage $swap_usage
printf "Local users:\t%s\n" $users
if [ $(cat .todo | head -c1 | wc -c) -ne 0 ]; then
		echo
		echo -e $(cat .todo)
fi
echo
if [ $tmux_state -eq 0 ]; then
	echo "Available tmux sessions:"
	echo "$tmux_sessions"
else
	echo "tmux is not running"
fi
echo

#setting up git bash prompt
if [ -f /etc/bash_completion ]; then
. /etc/bash_completion
fi

#PS1='\u@\h:\w$(__git_ps1) \$ '

__git_ps1 () 
{ 
    local b="$(git symbolic-ref HEAD 2>/dev/null)";
    if [ -n "$b" ]; then
        printf " (%s)" "${b##refs/heads/}";
    fi
}

case $(hostname) in
("inva")
	machineColor="0;36;40"
	;;
("coffeemaker")
	machineColor="0;33;40"
	;;
("Bebe")
	machineColor="0;35;40"
	;;
("tor-relay")
	machineColor="0;31;40"
	;;
("common")
	machineColor="1;31;40"
	;;
("pidoor")
	machineColor="0;34;40"
	;;
(*)
	machineColor="0;37;40"
	;;
esac

PS1="\t \[\e[38;5;253m\]\u\[\e[38;5;245m\]@\e[""$machineColor""m\h\[\e[m\]:\[\e[00;36m\][\w]\[\e[38;5;245m\]\$(__git_ps1)\[\e[0m\]\[\e[00;37m\]\[\e[0m\]\$\[\e[m\] \[\e[0;37m\]"

# uses hub (https://hub.github.com to make git more github friendly
eval "$(hub alias -s)"

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
alias l='ls'

#CD shortcut
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'

#Changing du to have a default comportement that I like better
alias du='du -sh'

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

#launch tmux in UTF8 mode (for putty)
alias tmux='tmux -u'

#using ip with colors
alias ip='ip -c'

#Weather in terminal (useless but pretty)
weather() {
  curl "http://wttr.in/${1-}";
}

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
          *.tar.bz2)   tar xvjf ./$1    ;;
          *.tar.gz)    tar xvzf ./$1    ;;
          *.tar.xz)    tar xvJf ./$1    ;;
          *.lzma)      unlzma ./$1      ;;
          *.bz2)       bunzip2 ./$1     ;;
          *.rar)       unrar x -ad ./$1 ;;
          *.gz)        gunzip ./$1      ;;
          *.tar)       tar xvf ./$1     ;;
          *.tbz2)      tar xvjf ./$1    ;;
          *.tgz)       tar xvzf ./$1    ;;
          *.zip)       unzip ./$1       ;;
          *.Z)         uncompress ./$1  ;;
          *.7z)        7z x ./$1        ;;
          *.xz)        unxz ./$1        ;;
          *.exe)       cabextract ./$1  ;;
          *)           echo "extract: '$1' - unknown archive method" ;;
        esac
    else
        echo "$1 - file does not exist"
    fi
fi
}

export EDITOR='vim'

#MODIFY PATH
export PATH=$PATH:/opt/node-v5.1.1-linux-x64/bin/
#path variables for go
export PATH=$PATH:/usr/local/go/bin
export GOPATH=~/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN
