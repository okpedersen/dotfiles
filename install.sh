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

install_kitty() {
  brew_casks+=(kitty)
  configuration_files+=(".config/kitty/kitty.conf")
}

install_spotify() {
  brew_casks+=(spotify)
}

upgrade_packages() {
  brew upgrade || true
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
  brew_casks+=('dotnet')
}

main() {
  # Add nix install
  XDG_NIX_DIR=~/.config/nixpkgs/
  mkdir -p $XDG_NIX_DIR
  mv $XDG_NIX_DIR/home.nix $XDG_NIX_DIR/home.nix.bk
  ln -s "$(pwd)/home.nix" ~/.config/nixpkgs/
  ln -s "$(pwd)/config.nix" ~/.config/nixpkgs/
  home-manager switch
  append_line_to_file_if_not_exists "${HOME}/.nix-profile/bin/zsh" /etc/shells "sudo"
  chsh -s "${HOME}/.nix-profile/bin/zsh"

  install_xcode_command_line_tools
  install_brew
  install_kitty
  install_spotify
  install_base16
  install_karabiner
  install_wslconf
  install_azure_functions

  upgrade_packages

  if is_macos; then
    local installed_casks
    installed_casks="$(brew list --cask)"
    for prog in "${brew_casks[@]}"; do
      if ! [[ "$installed_casks" =~ $prog ]]; then
        brew install --cask "$prog"
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
