#!/usr/bin/env zsh

# This script updates the the repository
# It doesn't compile submodules (like YCM), which must be done manually

SCRIPT_DIR=$0:A:h;

cd $SCRIPT_DIR;

git pull origin master;
git submodule update --init --recursive;

function syncFiles () {
    rsync                       \
        --exclude ".git/"       \
        --exclude ".gitignore"  \
        --exclude ".gitmodules" \
        --exclude "update.sh"   \
        --exclude "README.md"   \
        -avh --no-perms         \
        . ~;
    source ~/.zshrc;
}

syncFiles;
unset syncFiles;
