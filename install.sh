#!/usr/bin/env bash

# fail on errors
set -eou pipefail

. lib/util.sh

declare -a brew_formulas=()
declare -a brew_casks=()
declare -a configuration_funcs=()
declare -a configuration_files=()

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
  configuration_files+=(".inputrc")
  configuration_files+=(".bashrc")
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

install_rust(){
  brew_formulas+=(rust)
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
  sudo npm install -g neovim

  # TODO Python3 needs to be installed before this step
  nvim -c "PlugUpgrade | PlugUpdate | UpdateRemotePlugins" -c "qall"

  # TODO: Look into and clean init.vim
  # TODO: Use language-specific files
  # TODO: Handle plug vim - not in source control
}

install_zsh() {
  brew_formulas+=(zsh)
  configuration_files+=(".zshrc" ".zsh_common_settings" ".oh-my-zsh")
  # TODO: shell aliases
  # TODO: more zsh and .oh-my-zsh config
}

install_git() {
  brew_formulas+=(git)

  info "Put local configurations in XDG_CONFIG_HOME/git/config"
  configuration_files+=(".gitignore_global" ".gitconfig")
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

configure_fzf() {
  "$(brew --prefix)"/opt/fzf/install
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
  install_rust
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

  upgrade_packages

  local installed_casks
  installed_casks="$(brew cask list)"
  for prog in "${brew_casks[@]}"; do
    if ! [[ "$installed_casks" =~ $prog ]]; then
      /usr/local/bin/brew cask install "$prog"
    fi
  done

  local installed_formulas
  installed_formulas="$(brew list)"
  for prog in "${brew_formulas[@]}"; do
    if ! [[ "$installed_formulas" =~ $prog ]]; then
      /usr/local/bin/brew install "$prog"
    fi
  done

  # configuration files
  for file in "${configuration_files[@]}"; do
    local target_file="$HOME/$file"
    local source_file
    source_file="$(pwd)/$(basename "$file")"
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

  # install language runtimes: python2,3, js, npm, node, bash?
  # other tools:
  # - aliases
  # - custom scripts
}

main
