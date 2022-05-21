#!/bin/bash
source $(dirname $0)/shared/env.sh
source $(dirname $0)/shared/shared.sh

BASENAME=$(basename "$0")


move_file(){
    folderName=$(basename "$1")
    mv "$1" "$2/old/$folderName"
}
handle_folder(){
    for ENTRY in "$1"/*; do
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

        move_file "$ENTRY" "$1"
    done
}
main(){        
    for folder in "${MOVE_OLD_FILES_FOLDERS[@]}"; do
        handle_folder "$folder"
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