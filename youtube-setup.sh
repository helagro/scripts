#!/bin/bash
source env.sh

BASEDIR=$(dirname "$0")
SKIP_DOWNLOAD=$1

is_installed(){
    return -e $BASEDIR/installed/youtube-setup
}
has_internet(){
    return [ "$(ping -c 1 8.8.8.8 | grep '100% packet loss' )" != "" ]
}

rename_with_audio_name(){
    echo "Rename based on audio name"
    STRIPPED_AUDIO_NAME="${1%.mp3}"
    mv "$2" "$STRIPPED_AUDIO_NAME.MOV"
    mv "/Users/i/Creative Cloud Files/new-vid" "/Users/i/Creative Cloud Files/$STRIPPED_AUDIO_NAME"
}
install(){
    pip install gdown
    echo 'alias yt='$BASEDIR'/youtube-setup.sh' >> ~/.zshrc
    touch $BASEDIR/installed/youtube-setup
}

if [ is_installed ]; then
    if [ has_internet ]; then
        if [ SKIP_DOWNLOAD ]; then 
            cd /Users/i/Creative\ Cloud\ Files/new-vid/input
        else
            cp -r /Users/i/Creative\ Cloud\ Files/_video /Users/i/Creative\ Cloud\ Files/new-vid
            cd /Users/i/Creative\ Cloud\ Files/new-vid/input
            gdown --folder --id $DRIVE_FOLDER
        fi
        AUDIO_NAME=$(find . -name *.mp3)
        VIDEO_NAME=$(find . -name *.MOV)
        if [ "$AUDIO_NAME" != "" ]; then
            rename_with_audio_name "$AUDIO_NAME" $VIDEO_NAME
        else
            echo "Rename based on video name"
            mv "/Users/i/Creative Cloud Files/new-vid" "/Users/i/Creative Cloud Files/$VIDEO_NAME"
        fi
        open /Applications/Adobe\ Premiere\ Pro\ 2022/Adobe\ Premiere\ Pro\ 2022.app
    else
        echo "No Internet"
    fi
else
    install
fi