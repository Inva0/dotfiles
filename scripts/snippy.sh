#!/bin/bash
# Snippy, modified from : https://github.com/gotbletu/shownotes/blob/master/snippy.sh 
# Add a new file into the $DIR folder, the filename will be the snippet name 

DIR=${HOME}/.config/snippy
DMENU_ARGS="-i"
XSEL_ARGS="--clipboard --input"

cd ${DIR}

# Use the filenames in the snippy directory as menu entries.
# Get the menu selection from the user.
FILE=`find .  -type f | grep -v '^\.$' | grep -v "^\./all$" | sed 's!\.\/!!' | /usr/bin/dmenu ${DMENU_ARGS}`

if [ -f ${DIR}/${FILE} ]; then
  # Put the contents of the selected file into the paste buffer.
  xsel ${XSEL_ARGS} < ${DIR}/${FILE}
  # Paste into the current application.
  #xdotool key ctrl+v		#gui paste
  xdotool key ctrl+shift+v	#cli
fi
