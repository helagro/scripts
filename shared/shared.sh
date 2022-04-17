BASEDIR=$(dirname "$0")

is_installed_shared(){
    ls $BASEDIR/installed/$1
    return $?
}
install_shared(){
    echo 'alias yt='$BASEDIR'/'$1 >> ~/.zshrc
    touch $BASEDIR/installed/$1
    echo "Installed"
}

has_internet(){
    nc -zw1 google.com 443
    return $?
}