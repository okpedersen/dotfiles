if [[ -a $HOME/.sh_common_settings ]]; then
    source $HOME/.sh_common_settings
else
    echo "No shell common settings!";
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

### From default .bashrc ###

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
