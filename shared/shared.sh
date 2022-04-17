BASEDIR=$(dirname "$0")


get_install_check_file_path(){
    PATH=$BASEDIR/installed/$1
    PATH_WITHOUT_EXT="${PATH%.*}"
    echo $PATH_WITHOUT_EXT
}
is_installed_shared(){
    ls $(get_install_check_file_path $1)
    return $?
}
install_shared(){
    echo "alias $2=\""$BASEDIR'/'$1'"' >> ~/.zshrc
    touch $(get_install_check_file_path $1)
    echo "Installed"
}

has_internet(){
    nc -zw1 google.com 443
    return $?
}