#!/usr/bin/python3
import os
import sys

# assumes the dotfile directory is located in ~
# TODO: allow arguments
DOTFILES_DIR = os.path.dirname(os.path.abspath(__file__))
HOME_DIR = os.path.dirname(DOTFILES_DIR)

os.chdir(DOTFILES_DIR)

# fetch lates changes
cmd = 'git pull'
if os.system(cmd):
    print('{} failed'.format(cmd))
    sys.exit(1)
cmd = 'git submodule update --init --recursive'
if os.system(cmd):
    print('{} failed'.format(cmd))
    sys.exit(1)

# exclude files only requred for VCS/setup
EXCLUDE_FILES = set(('.git', '.gitignore', '.gitmodules', 'update.py', 'LICENSE', 'README.md'))
files = set(os.listdir(DOTFILES_DIR)) - EXCLUDE_FILES

# handle collisions
collisions = set(os.listdir(HOME_DIR)) & files
# TODO: handle collisions gracefully
if collisions:
    print("Got the following collisions:")
    print("\n".join(collisions))
    sys.exit(1)

# assumes unix (windows requries target_is_directory=True for directories)
for f in files:
    os.symlink(
            os.path.join(DOTFILES_DIR, f),
            os.path.join(HOME_DIR, f),
    )

print("done")
