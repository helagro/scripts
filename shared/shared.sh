BASEDIR=$(dirname "$0")

get_install_check_file_path(){
    PATH=$BASEDIR/installed/$1
    PATH_WITHOUT_EXT="${PATH%.*}"
    echo $PATH_WITHOUT_EXT
}
is_installed(){
    ls $(get_install_check_file_path $1) >/dev/null
    return $?
}
install_shared(){
    if [ ! -z "$2" ]; then
        echo "alias $2=\""$BASEDIR'/'$1'"' >> ~/.zshrc
    fi
    touch $(get_install_check_file_path $1)
    echo "Installed"
}

has_internet(){
    nc -zw1 google.com 443
    return $?
}

log(){
    MSG="$1: $2 --- $(date)"
    echo $MSG
    echo $MSG >> ./shared/logs.txt

    LINES_AMT_RES=$(wc -l <shared/logs.txt)
    LINES_AMT=$(echo $LINES_AMT_RES | xargs)
    if [[ $LINES_AMT > 1000 ]]; then
        LOGS_CONTENT=$(sed 1,100d shared/logs.txt)
        echo "$LOGS_CONTENT" > ./shared/logs.txt
    fi
}