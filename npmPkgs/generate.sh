#!/usr/bin/env bash
set -eou pipefail

if ! command -v node2nix > /dev/null; then
  echo "node2nix must be available in environment!"
  exit 2
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$DIR"
node2nix -i node-packages.json -o node-packages.nix -c composition.nix

