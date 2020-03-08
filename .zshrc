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

export PATH="/usr/local/bin:$PATH"
for prog in coreutils ed grep gnu-sed make; do
  export PATH="/usr/local/opt/$prog/libexec/gnubin:$PATH"
done

export MANPAGER="sh -c 'col -bx | bat -l man -p'"

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS=" --preview 'bat --color=always --style=numbers {} | head -500'"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
