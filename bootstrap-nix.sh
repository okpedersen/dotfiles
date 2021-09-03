#!/usr/bin/env bash

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
. "$HOME/.nix-profile/etc/profile.d/nix.sh"

# Use unstable nix to get commands & flakes
nix-env -iA nixpkgs.nixUnstable

mkdir -p "$HOME/.config/nix"
ln -sf "$SCRIPT_DIR/nix.conf" "$HOME/.config/nix/"

mkdir -p "$HOME/.config/nixpkgs"
ln -sf "$SCRIPT_DIR/flake.nix" "$HOME/.config/nixpkgs/flake.nix"

cd "$SCRIPT_DIR"

if is_linux || is_macos; then
  # home-manager is default
  nix run . switch
else
  echo "Unrecognized system"
  exit 1
fi

