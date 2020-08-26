echo "Installing dotfiles for user : $USER"

read -r -p "Replaced files will be backed up. Continue? [Y/n] " response
response=${response,,} # tolower
echo
if [[ ! $response =~ ^(yes|y| ) ]] & [ ! -z $response ]; then
	echo "Cancelling"
	exit 1
fi

#Creating back up dir
bakdir=".dotfiles_bak_$(date +%Y-%m-%d)"
mkdir ~/$bakdir

bakused=false;

#going through files, backing up if necessary
for f in $(ls -a | grep -P '^\.(?!git$)(?!\.).+$')
do
	if [ -f ~/$f ]; then
		cp ~/$f ~/$bakdir/$f
		bakused=true;
	fi
	ln -fs $(pwd)/$f ~/$f
	
done

if [ $bakused = false ]; then
	rmdir ~/$bakdir
	echo "No files were overwritten"
else
	echo "Backed up files available in ~/$bakdir"
fi

echo

if [ ! -f ~/.git-prompt.sh ]; then
    echo "Downloading git-prompt"
    curl -o ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
	echo
fi

if [ ! -f ~/.lastweather ]; then
	touch -t '197001010000' ~/.lastweather
fi

echo "You can now load your new config by sourcing the bashfile:"
echo
echo ". ~/.bashrc"
echo
