#!/bin/bash
# Open a dmenu for system wide snippet
# modified from
# from https://github.com/gotbletu/shownotes/blob/master/snippy_1line.sh
# Create a new snippet: 
# [tag] some message here
# there are a "date" and "datetime" snippets


SNIPPET_FILE=${HOME}/.config/snippy/all
DMENU_ARGS="-i"
XSEL_ARGS="--clipboard --input"

DATE=$(date +"%m-%d-%Y")
DATETIME=$(date +"%m-%d-%Y %H:%M")

# Display the menu and get the selection
CHOICE="`sed 's/\].*/]/' ${SNIPPET_FILE}`"

SELECTION=`echo -e "$CHOICE" | /usr/bin/dmenu ${DMENU_ARGS}`

# Strip out the square brackets...
PATTERN=`echo ${SELECTION} | tr -d "[]"`

# ...and put them back in, escaped with a backslash.
# Get the text associated with the selection.
TEXT=`grep "\[${PATTERN}\]" ${SNIPPET_FILE} | sed "s/\[${PATTERN}\] //"`
if [ "${TEXT}" = "DATE_PLACEHOLDER" ]; then
	echo -n ${DATE} | xsel ${XSEL_ARGS}
	xdotool key ctrl+shift+v
	exit
fi

if [ "${TEXT}" = "DATETIME_PLACEHOLDER" ]; then
	echo -n ${DATETIME} | xsel ${XSEL_ARGS}
	xdotool key ctrl+shift+v
	exit
fi

if [ "${TEXT}" ]; then
  # Put the selected string (without the trailing newline) into the paste buffer.
  echo -n ${TEXT} | xsel ${XSEL_ARGS}
  # Paste into the current application.
  #xdotool key ctrl+v		#gui paste
  xdotool key ctrl+shift+v	#cli
fi

