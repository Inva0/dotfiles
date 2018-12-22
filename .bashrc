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

# random color for each host

if [ ! -f ~/.host_color ]; then
	echo "Host color not found, created : "
	echo -e "\e[3$(( $RANDOM * 6 / 32767 + 1 ))m">~/.host_color
	echo -e "$(cat ~/.host_color) This color !\033[0m"
fi

# docker alias
source ~/.dockerfunc

#setting up git bash prompt
if [ -f  /etc/bash_completion ]; then
	. /etc/bash_completion
fi

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '

#PS1='\u@\h:\w$(__git_ps1) \$ '
if id -u | grep -qw "0"; then
	PS1_COLOR="31m" # Redish
elif id -nG "$USER" | grep -qw "adm"; then
	PS1_COLOR="33m" # Yellowish
else
	PS1_COLOR="36m" # Blueish
fi

PS1="\t " # prompt time
PS1="$PS1\[\e[$PS1_COLOR\]"        # user color
PS1="$PS1\u"                       # user name
PS1="$PS1@"                        # add @ between user name and host
PS1="$PS1\[$(cat ~/.host_color)\]" # set color with predefined colors (see above)
PS1="$PS1\h"                       # host name
PS1="$PS1\[\e[00;36m\]"            # blue color for directory
PS1="$PS1[\w]"                     # working directory, inside '[' and ']'
PS1="$PS1\$(__git_ps1)"             # add git info
PS1="$PS1\[\e[37;00m\]"            # reset color
PS1="$PS1\$ "                  # add $ and a space at the end

umask 022

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
if [ -x "$(command -v exa)" ]; then
    alias ls='exa --color=auto'
else
    alias ls='ls --color=auto'
fi

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

alias lisbeth="ssh edznux@edznux.fr"

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

function git-work(){
	EMAIL=$1
	git log --shortstat --author $EMAIL | \
	grep -E "files? changed" | \
	awk '{files+=$1; inserted+=$4; deleted+=$6} END {print "\nfile :", files, "\ninserted : ", inserted, "deleted", deleted}'Ressource
}

# Add color to man pages
# thanks to https://github.com/jessfraz/dotfiles/blob/master/.functions
man() {
	env \
		LESS_TERMCAP_mb="$(printf '\e[1;31m')" \
		LESS_TERMCAP_md="$(printf '\e[1;31m')" \
		LESS_TERMCAP_me="$(printf '\e[0m')" \
		LESS_TERMCAP_se="$(printf '\e[0m')" \
		LESS_TERMCAP_so="$(printf '\e[1;44;33m')" \
		LESS_TERMCAP_ue="$(printf '\e[0m')" \
		LESS_TERMCAP_us="$(printf '\e[1;32m')" \
		man "$@"
}

# MODIFY PATH
export PATH=$PATH:/opt/node-v5.1.1-linux-x64/bin/

# SET ENV VAR
export EDITOR='vim'

# PATH for Golang
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

# PATH for Rust
export PATH=$PATH:$HOME/.cargo/bin/

# source tools
source /usr/local/bin/z/z.sh

# added by travis gem
[ -f /home/edznux/.travis/travis.sh ] && source /home/edznux/.travis/travis.sh

export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Devel
source ~/.local/bin/virtualenvwrapper.sh

export GPG_TTY=$(tty)
