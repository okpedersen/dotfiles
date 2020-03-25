#!/usr/bin/env bash

# fail on errors
set -eou pipefail

. lib/util.sh

declare -a brew_formulas=()
declare -a brew_casks=()
declare -a configuration_funcs=()
declare -a configuration_files=()

install_xcode_command_line_tools() {
  if is_macos; then
    xcode-select --install || true
  fi
}

install_brew() {
  if utility_exists brew; then
    info "Brew already exists."
    return 0
  fi

  if is_macos; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    sudo apt-get install build-essential curl file git
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    append_line_to_file_if_not_exists 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' "${HOME}"/.profile
    append_line_to_file_if_not_exists 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' "${HOME}"/.zprofile
    # sudo should also have access to brew utils
    local exports
    exports="$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    if ! sudo grep -q "HOMEBREW" /root/.profile; then
      echo "$exports" | sudo tee -a /root/.profile
    fi
    # Only source bash, since we're running a bash script
    source "${HOME}/.profile"
  fi
}

install_basic_tools() {
  # make standard unix tools available in macOS
  brew_formulas+=(
    coreutils binutils diffutils ed findutils gawk gnu-indent gnu-sed gnu-tar
    gnu-which gnutls grep gzip screen watch wdiff wget bash gpatch less
    m4 make cmake file-formula perl rsync unzip
  )
  configuration_files+=(".inputrc")
  configuration_files+=(".bashrc" ".sh_common_settings")
}

install_kitty() {
  brew_casks+=(kitty)
  configuration_files+=(".config/kitty/kitty.conf")
}

install_spotify() {
  brew_casks+=(spotify)
}

install_python2() {
  brew_formulas+=(python@2)
}

install_python3() {
  brew_formulas+=(python)
}

install_rust(){
  brew_formulas+=(rust)
}

install_npm() {
  brew_formulas+=(node npm)
}

install_tmux() {
  brew_formulas+=(tmux)
  configuration_files+=(".tmux.conf")
}

install_neovim() {
  brew_formulas+=(neovim)
  configuration_files+=(".config/nvim")
  configuration_funcs+=("configure_neovim")
}

configure_neovim() {
  pip2 install pynvim neovim
  pip3 install pynvim
  sudo -i npm install -g neovim

  curl -fLo nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  nvim -c "PlugUpgrade | PlugUpdate | UpdateRemotePlugins" -c "qall"
}

install_zsh() {
  brew_formulas+=(zsh)
  configuration_files+=(".zshrc" ".zsh_common_settings" ".oh-my-zsh" ".sh_common_settings")
  configuration_funcs+=("configure_zsh")
}

configure_zsh() {
  git submodule update --init --recursive

  local zsh_path
  zsh_path="$(command -v zsh)"

  append_line_to_file_if_not_exists "$zsh_path" /etc/shells "sudo"

  if ! [[ $SHELL =~ ^/.*/zsh$ ]]; then
    chsh -s "$zsh_path"
  fi
}

install_git() {
  brew_formulas+=(git)

  info "Put local configurations in XDG_CONFIG_HOME/git/config"
  configuration_files+=(".gitignore_global" ".gitconfig")
}

install_bat() {
  brew_formulas+=(bat)
}

install_jq() {
  brew_formulas+=(jq)
}

install_shellcheck() {
  brew_formulas+=(shellcheck)
}

install_diff_so_fancy() {
  brew_formulas+=(diff-so-fancy)
}

install_ripgrep() {
  brew_formulas+=(ripgrep)
}

install_exa() {
  brew_formulas+=(exa)
}

install_fd() {
  brew_formulas+=(fd)
}

install_fzf() {
  brew_formulas+=(fzf)
  if ! utility_exists fzf; then
    configuration_funcs+=("configure_fzf")
  fi
}

install_gitmoji() {
  brew_formulas+=(gitmoji)
}

configure_fzf() {
  "$(brew --prefix)"/opt/fzf/install
}

upgrade_packages() {
  brew upgrade || true

  if is_macos; then
    brew cask upgrade
  fi
}

install_base16() {
  if [[ ! -d "${HOME}"/.config/base16-shell ]]; then
    git clone https://github.com/chriskempson/base16-shell "${HOME}"/.config/base16-shell
  fi
  info "Change shell colors with base16_*"
}

install_karabiner() {
  if is_macos; then
    configuration_files+=(".config/karabiner/karabiner.json")
    configuration_files+=(".config/karabiner/assets/complex_modifications/karabiner_norwegian_with_caps_lock.json")
    configuration_files+=(".config/karabiner/assets/complex_modifications/karabiner_switch_paragraph_sign_and_backquote.json")
  fi
}

main() {
  install_xcode_command_line_tools
  install_brew
  install_basic_tools
  install_kitty
  install_spotify
  install_python2
  install_python3
  install_rust
  install_npm
  install_tmux
  install_neovim
  install_zsh
  install_git
  install_bat
  install_jq
  install_shellcheck
  install_diff_so_fancy
  install_ripgrep
  install_exa
  install_fd
  install_fzf
  install_gitmoji
  install_base16
  install_karabiner

  upgrade_packages

  if is_macos; then
    local installed_casks
    installed_casks="$(brew cask list)"
    for prog in "${brew_casks[@]}"; do
      if ! [[ "$installed_casks" =~ $prog ]]; then
        brew cask install "$prog"
      fi
    done
  fi

  local installed_formulas
  installed_formulas="$(brew list)"
  for prog in "${brew_formulas[@]}"; do
    if ! [[ "$installed_formulas" =~ $prog ]]; then
      brew install "$prog"
    fi
  done

  # configuration files
  for file in "${configuration_files[@]}"; do
    local target_file="$HOME/$file"
    local source_file
    source_file="$(pwd)/$(basename "$target_file")"
    mkdir -p "$(dirname "$target_file")"
    if [[ ! -f "$target_file" ]] && [[ ! -d "$target_file" ]]; then
      ln -s "$source_file" "$target_file"
    elif [[ ! -h "$target_file" ]]; then
      warn "$target_file is not a symbolic link"
    fi
  done

  # configuration funcs
  for func in "${configuration_funcs[@]}"; do
    $func
  done
}

main
