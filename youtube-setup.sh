#!/bin/bash
BASEDIR=$(dirname "$0")

if [ -e $BASEDIR/installed/youtube-setup ]
then
    cp -r /Users/i/Creative\ Cloud\ Files/_video /Users/i/Creative\ Cloud\ Files/new-vid
    cd /Users/i/Creative\ Cloud\ Files/new-vid/input
    gdown --folder --id 1Xex1jsN5DB8ShB4jUVTuqJVLSvjVGwJy
    AUDIO_NAME=$(find . -name *.mp3)
    STRIPPED_AUDIO_NAME="${AUDIO_NAME%.mp3}"
    VIDEO_NAME=$(find . -name *.MOV)
    mv $VIDEO_NAME $STRIPPED_AUDIO_NAME.MOV 
    mv /Users/i/Creative\ Cloud\ Files/new-vid /Users/i/Creative\ Cloud\ Files/$STRIPPED_AUDIO_NAME
    open /Applications/Adobe\ Premiere\ Pro\ 2022/Adobe\ Premiere\ Pro\ 2022.app
else
    pip install gdown
    echo 'alias yt="/Users/i/Documents/github/scripts/youtube-setup.sh"' >> ~/.zshrc
    touch $BASEDIR/installed/youtube-setup
fi

