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

  if is_wsl; then
    sudo hwclock --hctosys # sync clock - can cause troubles if not
  fi

  if is_macos; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    sudo apt-get update
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
  configuration_files+=(".bashrc" ".sh_common_settings")
}

install_kitty() {
  brew_casks+=(kitty)
  configuration_files+=(".config/kitty/kitty.conf")
}

install_spotify() {
  brew_casks+=(spotify)
}

install_tmux() {
  brew_formulas+=(tmux)
  configuration_files+=(".tmux.conf")
}

install_neovim() {
  brew_formulas+=(luarocks)
  brew install --HEAD neovim  # required to get nvim v0.5
  configuration_files+=(".config/nvim")
  configuration_funcs+=("configure_neovim")
}

configure_neovim() {
  if utility_exists pip2; then
    pip2 install pynvim neovim
  fi
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

install_fzf() {
  brew_formulas+=(fzf)
  if ! [ -f ~/.fzf.zsh ]; then
    configuration_funcs+=("configure_fzf")
  fi
}

configure_fzf() {
  "$(brew --prefix)"/opt/fzf/install --all
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

install_wslconf() {
  if is_wsl; then
    sudo cp "$(pwd)/wsl/wsl.conf" /etc/wsl.conf
  fi
}

install_azure_functions() {
  brew tap azure/functions
  brew_casks+=('dotnet')
  brew_formulas+=('azure-cli' 'azure-functions-core-tools@3')
}

main() {
  install_xcode_command_line_tools
  install_brew
  install_basic_tools
  install_kitty
  install_spotify
  install_tmux
  install_neovim
  install_zsh
  install_fzf
  install_base16
  install_karabiner
  install_wslconf
  install_azure_functions

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

  echo "Done!"
}

main
