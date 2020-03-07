#!/usr/bin/env bash

# fail on errors
set -eou pipefail

. lib/util.sh

declare -a brew_formulas=()
declare -a brew_casks=()

install_xcode_command_line_tools() {
  xcode-select --install || true
}


install_brew() {
  if ! is_macos; then
    warn "Cannot install brew on non-macOS system!"
    return 1
  fi

  if utility_exists brew; then
    info "Brew already exists."
    return 0
  fi

  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

install_basic_tools() {
  brew_formulas+=(
    coreutils binutils diffutils ed findutils gawk gnu-indent gnu-sed gnu-tar
    gnu-which gnutls grep gzip screen watch wdiff wget bash gpatch less
    m4 make cmake file-formula openssh perl rsync unzip
  )
}

install_kitty() {
  brew_casks+=(kitty)
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

install_tmux() {
  brew_formulas+=(tmux)

  local target_file="$HOME/.tmux.conf" 
  if [[ ! -f "$target_file" ]]; then
    ln -s "$(pwd)/.tmux.conf" "$target_file"
  elif [[ ! -h "$target_file" ]]; then
    warn "$target_file is not a symbolic link"
  fi
}

install_neovim() {
  if utility_exists nvim; then
    info "Neovim already exsists."
  else
    /usr/local/bin/brew install neovim
  fi

  pip2 install pynvim neovim
  pip3 install pynvim
  sudo npm install -g neovim

  local target_file="$HOME/.config/nvim" 
  if [[ ! -d "$target_file" ]]; then
    ln -s "$(pwd)/nvim" "$target_file"
  elif [[ ! -h "$target_file" ]]; then
    warn "$target_file is not a symbolic link"
  fi

  nvim -c "PlugUpgrade | PlugUpdate | UpdateRemotePlugins | qall"

  # TODO: Look into and clean init.vim
  # TODO: Use language-specific files
  # TODO: Handle plug vim - not in source control
}

install_common_shell_utils() {
  local target_file="$HOME/.inputrc" 
  if [[ ! -f "$target_file" ]]; then
    ln -s "$(pwd)/.inputrc" "$target_file"
  elif [[ ! -h "$target_file" ]]; then
    warn "$target_file is not a symbolic link"
  fi

}

install_bash() {
  # latest bash version is installed by install_basic_tools
  local target_file="$HOME/.bashrc" 
  if [[ ! -f "$target_file" ]]; then
    ln -s "$(pwd)/.bashrc" "$target_file"
  elif [[ ! -h "$target_file" ]]; then
    warn "$target_file is not a symbolic link"
  fi
}

install_zsh() {
  brew_formulas+=(zsh)
  local -a files
  files=(.zshrc .zsh_common_settings)
  for file in "${files[@]}"; do
    local target_file="$HOME/$file" 
    if [[ ! -f "$target_file" ]]; then
      ln -s "$(pwd)/$file" "$target_file"
    elif [[ ! -h "$target_file" ]]; then
      warn "$target_file is not a symbolic link"
    fi
  done

  local target_file="$HOME/.oh-my-zsh" 
  if [[ ! -d "$target_file" ]]; then
    ln -s "$(pwd)/.oh-my-zsh" "$target_file"
  elif [[ ! -h "$target_file" ]]; then
    warn "$target_file is not a symbolic link"
  fi
  # TODO: shell aliases
  # TODO: more zsh and .oh-my-zsh config
}

install_git() {
  brew_formulas+=(git)

  info "Put local configurations in XDG_CONFIG_HOME/git/config"

  local target_files=(".gitignore_global" ".gitconfig")
  for file in "${target_files[@]}"; do
    local target_file="$HOME/$file" 
    if [[ ! -f "$target_file" ]]; then
      ln -s "$(pwd)/$file" "$target_file"
    elif [[ ! -h "$target_file" ]]; then
      warn "$target_file is not a symbolic link"
    fi
  done
  # TODO: git aliases
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

upgrade_packages() {
  /usr/local/bin/brew upgrade
  /usr/local/bin/brew cask upgrade
}


main() {
  install_xcode_command_line_tools
  install_brew
  install_basic_tools
  install_kitty
  install_spotify
  install_python2
  install_python3
  install_tmux
  install_neovim
  install_common_shell_utils
  install_bash
  install_zsh
  install_git
  install_bat
  install_jq
  install_shellcheck

  upgrade_packages

  brew cask install "${brew_casks[@]}"
  brew install "${brew_formulas[@]}"
  # install language runtimes: python2,3, js, npm, node, bash?
  # other tools:
  # - aliases
  # - custom scripts
}

main
