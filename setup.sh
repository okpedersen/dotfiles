#!/usr/bin/env zsh

SCRIPT_DIR=$0:A:h;

cd $SCRIPT_DIR;

git pull origin master;
git submodule update;

function syncFiles () {
    rsync                       \
        --exclude ".git/"       \
        --exclude ".gitignore"  \
        --exclude ".gitmodules" \
        --exclude "setup.sh"    \
        --exclude "README.md"   \
        -avh --no-perms         \
        . ~;
    source ~/.zshrc;
}

syncFiles;
unset syncFiles;
