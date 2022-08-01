#!/usr/bin/env bash

set -eou pipefail

ROOT_DIR="$(git rev-parse --show-toplevel)"

# shellcheck source=/dev/null
. "$ROOT_DIR/lib/util.sh"

if ! is_linux && ! is_macos; then
  echo "Bootstrapping on current OS not supported" >&2
  exit 1
fi

echo "Installing Nix"
if is_macos; then
  sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume
elif is_linux; then
  curl -L https://nixos.org/nix/install | sh
else
  echo "Unrecognized system" >&2
  exit 1
fi

mkdir -p "$HOME/.config/nix"
ln -sf "$ROOT_DIR/nix.conf" "$HOME/.config/nix/"

mkdir -p "$HOME/.config/nixpkgs"
ln -sf "$ROOT_DIR/flake.nix" "$HOME/.config/nixpkgs/flake.nix"

echo "Nix installed, run the switch script in scripts/ to perform first home-manager switch." 
