TERM="screen-256color"

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

export PATH="/usr/local/bin:$PATH"
for prog in coreutils ed grep gnu-sed make; do
  export PATH="$(brew --prefix $prog)/libexec/gnubin:$PATH"
done

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
