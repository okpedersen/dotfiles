if [[ -a $HOME/.zsh_common_settings ]]; then
    source $HOME/.zsh_common_settings
else
    echo "No common settings!";
fi
if [[ -a $HOME/.zsh_virtualenv_settings ]]; then
    source $HOME/.zsh_virtualenv_settings
fi
if [[ -a $HOME/.zsh_local_settings ]]; then
    source $HOME/.zsh_local_settings
else
    echo "No local settings!";
fi
