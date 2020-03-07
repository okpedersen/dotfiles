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
  export PATH="$(brew --prefix $prog)/libexec/gnubin:$PATH"
done
