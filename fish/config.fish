
# load colors for shell
if status --is-interactive
    set BASE16_SHELL "$HOME/.config/base16-shell/"
    source "$BASE16_SHELL/profile_helper.fish"
end

# use neovim editor
export EDITOR=/usr/bin/nvim
export TERM=screen-256color
