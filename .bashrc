if [[ -a $HOME/.sh_common_settings ]]; then
    source $HOME/.sh_common_settings
else
    echo "No shell common settings!";
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
