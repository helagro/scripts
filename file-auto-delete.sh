#!/bin/bash
source $(dirname $0)/shared/env.sh
source $(dirname $0)/shared/shared.sh

OTHER_MAX_AGE=182
MAX_EMPTY_FOLDER_AGE=10
EXTS_AND_MAX_AGE=( "zip" 30 "png" -30 "jpg" 30 "DS_Store" 10)

BASENAME=$(basename "$0")


delete_file(){
    trash "$1"
    log $BASENAME "Deleted file $1"
}
handle_file(){
    EXT="${1##*.}"
    for (( i = 0; i < ${#EXTS_AND_MAX_AGE[@]}; i+=2 )); do
        if [[ "$EXT" = ${EXTS_AND_MAX_AGE[i]} ]] && [[ $(find "$1" -mtime +${EXTS_AND_MAX_AGE[i+1]} -print) ]]; then
            delete_file "$1"
            return
        fi
    done
    if [[ $(find "$1" -mtime +$OTHER_MAX_AGE -print) ]]; then
        delete_file "$1"
    fi
}
handle_folder(){        
    if [ -n "$(find "$1" -maxdepth 0 -type d -empty 2>/dev/null)" ]; then
        if [[ $(find "$1" -mtime +$MAX_EMPTY_FOLDER_AGE -print) ]]; then
            rm -r "$1"
            echo "Removed folder $1"
        fi
        return
    fi
    for ENTRY in "$1"/*; do
        if [ -d "$ENTRY" ]; then
            handle_folder "$ENTRY"
        else
            handle_file "$ENTRY"
        fi
    done
}
main(){
    shopt -s dotglob
    for DIR in $AUTO_DELETE_FOLDERS; do
        handle_folder $DIR
    done
}

install(){
    brew install trash
    install_shared "$BASENAME"
    echo "Add script to login items"
}

if is_installed $BASENAME; then
    main 
else 
    install
fi