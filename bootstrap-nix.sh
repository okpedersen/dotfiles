#!/usr/bin/env bash

set -eou pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

. lib/util.sh

if ! is_linux; then
  echo "Bootstrapping on current OS not supported"
  exit 1
fi

echo "Installing Nix"
curl -L https://nixos.org/nix/install | sh
. "$HOME/.nix-profile/etc/profile.d/nix.sh"
nix-env -iA nixpkgs.nixUnstable
mkdir -p "$HOME/.config/nix"
ln -sf "$SCRIPT_DIR/nix.conf" "$HOME/.config/nix/"
mkdir -p "$HOME/.config/nixpkgs"
ln -sf "$SCRIPT_DIR/flake.nix" "$HOME/.config/nixpkgs/flake.nix"

cd "$SCRIPT_DIR"
# home-manager is default
nix run . switch

