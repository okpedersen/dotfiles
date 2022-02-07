#!/usr/bin/env bash

NO_SWITCH=false
if [[ "$1" == "--no-switch" ]]; then
  NO_SWITCH=true
fi

set -eou pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

. lib/util.sh

if ! is_linux && ! is_macos; then
  echo "Bootstrapping on current OS not supported"
  exit 1
fi

echo "Installing Nix"
if is_macos; then
  sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume
elif is_linux; then
  curl -L https://nixos.org/nix/install | sh
else
  echo "Unrecognized system"
  exit 1
fi

# Source manually to run nix commands in this script
set +euo pipefail
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh 
set -euo pipefail

mkdir -p "$HOME/.config/nix"
ln -sf "$SCRIPT_DIR/nix.conf" "$HOME/.config/nix/"

mkdir -p "$HOME/.config/nixpkgs"
ln -sf "$SCRIPT_DIR/flake.nix" "$HOME/.config/nixpkgs/flake.nix"

cd "$SCRIPT_DIR"

if [[ $NO_SWITCH == true ]]; then
  exit 0
fi

if is_linux || is_macos; then
  # home-manager is default
  nix run . switch
else
  echo "Unrecognized system"
  exit 1
fi

