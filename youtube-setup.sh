#!/bin/bash
source shared/env.sh
source shared/shared.sh


BASENAME=$(basename "$0")
BASEDIR=$(dirname "$0")
SKIP_DOWNLOAD="${1:-0}"
VIDEOS_DIR="/Users/i/Creative Cloud Files/"


prepare_and_download(){
	if [ -e "$VIDEOS_DIR""new-vid" ]; then
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
    mv "$VIDEOS_DIR""new-vid" "$VIDEOS_DIR"$STRIPPED_AUDIO_NAME
}

local_install(){
    pip install gdown
    install_shared $BASENAME
}

main(){
    if is_installed_shared $BASENAME; then
        if has_internet; then
            if [[ $* == *--skip-download* ]]; then 
                echo "Skipping download"
                cd "$VIDEOS_DIR""new-vid/input"
            else
                prepare_and_download
            fi
            rename
            open /Applications/Adobe\ Premiere\ Pro\ 2022/Adobe\ Premiere\ Pro\ 2022.app
        else
            echo "No Internet"
        fi
    else
        local_install
    fi
}

if [ "$1" == "-h" ]; then
    echo "Flags: --skip-download";
else
    main
fi