#!/usr/bin/env bash

set -eou pipefail

ROOT_DIR="$(git rev-parse --show-toplevel)"

# shellcheck source=/dev/null
. "$ROOT_DIR/lib/util.sh"

ZSH_LOCATION="${HOME}/.nix-profile/bin/zsh"
if [[ ! -e "$ZSH_LOCATION" ]]; then
  echo "Could not find $ZSH_LOCATION. Aborting." >&2
  exit 1
fi

append_line_to_file_if_not_exists "$ZSH_LOCATION" /etc/shells "sudo"
chsh -s "$ZSH_LOCATION"
