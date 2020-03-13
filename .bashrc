TERM="screen-256color"

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"


if [[ -a $HOME/.sh_common_settings ]]; then
    source $HOME/.sh_common_settings
else
    echo "No shell common settings!";
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
