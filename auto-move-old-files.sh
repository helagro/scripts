#!/bin/bash
source $(dirname $0)/shared/env.sh
source $(dirname $0)/shared/shared.sh

BASENAME=$(basename "$0")


move_file(){
    folderName=$(basename "$1")
    mv "$1" "$2/old/$folderName"
}
handle_folder(){
    MAX_AGE=$2
    : ${MAX_AGE:=100}

    for ENTRY in "$1"/*; do
        if [[ ! $(find "$ENTRY" -mtime +$MAX_AGE -print) ]]; then
            continue
        fi
        TAGS=$(tag -l "$ENTRY")
        if [[ "$TAGS" == *Blue* ]]; then
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
        handle_folder "$folder" "$1"
    done
}

install(){
    brew install tag
    install_shared "$BASENAME"
    echo "Add script to login items"
}

if is_installed $BASENAME; then
    main $1
else 
    install
fi