#!/bin/bash
source $(dirname $0)/shared/env.sh
source $(dirname $0)/shared/shared.sh

BASENAME=$(basename "$0")


move_folder(){
    folderName=$(basename "$1")
    mv "$1" "$YOUTUBE_FOLDER/old/$folderName"
}
main(){        
    for ENTRY in "$YOUTUBE_FOLDER"/*; do
        if [[ ! $(find "$ENTRY" -mtime +28 -print) ]]; then
            continue
        fi
        TAGS=$(tag -l "$ENTRY")
        if [[ "$TAGS" == *Red* ]]; then
            continue
        fi
        if [[ "$ENTRY" == *_video ]]; then
            continue
        fi

        move_folder "$ENTRY"
    done
}

install(){
    brew install tag
    install_shared "$BASENAME"
    echo "Add script to login items"
}

if is_installed $BASENAME; then
    main 
else 
    install
fi