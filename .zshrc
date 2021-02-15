if [[ -a $HOME/.zsh_common_settings ]]; then
    source $HOME/.zsh_common_settings
else
    echo "No zsh common settings!";
fi
if [[ -a $HOME/.sh_common_settings ]]; then
    source $HOME/.sh_common_settings
else
    echo "No shell common settings!";
fi
if [[ -a $HOME/.zsh_virtualenv_settings ]]; then
    source $HOME/.zsh_virtualenv_settings
fi
if [[ -a $HOME/.zsh_local_settings ]]; then
    source $HOME/.zsh_local_settings
else
    echo "No local settings!";
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -e ~/.nix-profile/etc/profile.d/nix.sh ] && . ~/.nix-profile/etc/profile.d/nix.sh
