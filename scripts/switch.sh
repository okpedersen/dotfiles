#!/usr/bin/env bash

set -euo pipefail

if ! command -v home-manager &> /dev/null; then
  SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
  ROOT_DIR="$(cd "$SCRIPT_DIR" && git rev-parse --show-toplevel)"
  cd "$ROOT_DIR"

  # Source manually to run nix commands in this script
  NIX_DAEMON_SCRIPT=/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  if [[ ! -e $NIX_DAEMON_SCRIPT ]]; then
    echo "home-manager command not available and $NIX_DAEMON_SCRIPT not found. Cannot perform switch." >&2
    exit 1
  fi

  set +euo pipefail
  # shellcheck source=/dev/null
  . $NIX_DAEMON_SCRIPT
  set -euo pipefail

  nix run . switch
else
  home-manager switch
fi



