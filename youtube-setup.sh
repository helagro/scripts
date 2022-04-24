#!/bin/bash
source $(dirname $0)/shared/env.sh
source $(dirname $0)/shared/shared.sh


BASENAME=$(basename "$0")
VIDEOS_DIR="/Users/i/Creative Cloud Files/"


prepare_and_download(){
    if ! has_internet; then
        echo "No Internet"
        exit 1
    elif [ -e "$VIDEOS_DIR""new-vid" ]; then
		echo "remove 'new-vid' folder first"
		exit 1
	fi

	cp -r "$VIDEOS_DIR""_video" "$VIDEOS_DIR""new-vid"
	cd "$VIDEOS_DIR""new-vid/input"
	gdown --folder $DRIVE_FOLDER
}

rename(){
	AUDIO_NAME=$(find . -name *.mp3)
	VIDEO_NAME=$(find . -name *.MOV)
	if [ "$AUDIO_NAME" != "" ]; then
		rename_with_audio_name "$AUDIO_NAME" "$VIDEO_NAME"
	else
		echo "Rename based on video name"
		mv "$VIDEOS_DIR""new-vid" "$VIDEOS_DIR"$VIDEO_NAME
	fi
}
rename_with_audio_name(){
    echo "Rename based on audio name"
    STRIPPED_AUDIO_NAME="${1%.mp3}"
    mv "$2" "$STRIPPED_AUDIO_NAME.MOV"
    mv "$VIDEOS_DIR""new-vid" "$VIDEOS_DIR""$STRIPPED_AUDIO_NAME"
}

local_install(){
    pip install gdown
    install_shared $BASENAME "yt"
}

main(){
    if is_installed $BASENAME; then
        if [[ "$1" == "-l" ]]; then 
            echo "Skipping download"
            cd "$VIDEOS_DIR""new-vid/input"
        else
            prepare_and_download
        fi
        rename
        open /Applications/Adobe\ Premiere\ Pro\ 2022/Adobe\ Premiere\ Pro\ 2022.app
    else
        local_install
    fi
}

if [ "$1" == "-h" ]; then
    echo "Flags: -l  :Skips download, uses local folder named new-vid";
else
    main $1
fi