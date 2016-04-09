echo "installing dotfiles for user : $USER"

read -p "Continue? [Y/n]" -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Cancelling"
    exit 1
fi

#init
echo "Initialisation"
shopt -s extglob

echo "Suppression du dossier /tmp/dotfiles_install_$USER"
rm /tmp/dotfiles_install_$USER -rf
echo "Creation du dossier temp"
mkdir /tmp/dotfiles_install_$USER

#copy files
echo "copy into tmp folder"
cp ./.*!(.git|*.md|LICENSE) /tmp/dotfiles_install_$USER

if [ "$1" = "trace" ]; then
	echo "Trace mode, no delete"
else
	shopt -s dotglob
        echo "copying into your local home ($HOME)"
        mv /tmp/dotfiles_install_$USER/* $HOME
	rm /tmp/dotfiles_install_$USER/ -rf
fi

if [ ! -f "~/.git-prompt.sh"]; then
	curl -o ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
fi

echo "now you should execute the next command for reloading your config"
echo
echo ". ~/.bashrc"
echo

