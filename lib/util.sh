#!/usr/bin/env bash

is_macos() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    return 0
  else
    return 1
  fi
}

is_wsl() {
  if grep -qEi "(microsoft|wsl)" /proc/version &> /dev/null; then
    return 0
  else
    return 1
  fi
}

append_line_to_file_if_not_exists() {
  local txt="$1"
  local file="$2"
  if ! grep -q "$txt" "$file"; then
    echo "$txt" >> "$file"
  fi
}

# utility functions
debug() {
  echo "[DEBUG]: $1" >&2
}

info() {
  echo "[INFO]: $1" >&2
}

warn() {
  echo "[WARNING]: $1" >&2
}

confirm() {
  local message
  if [ $# -eq 0 ]; then
    message="Are you sure?"
    warn "No message supplied!"
  else
    message="$1"
  fi

  message="$message [y/N] "

  local response
  read -p "$message" -r response
  if [[ $response =~ ^[Yy]$ ]]; then
    return 0; # true
  fi

  return 1; # false
}

utility_exists() {
  if command -v "$1" >/dev/null || \
     (is_macos && open -Ra "$1" 2>/dev/null); then
    return 0
  else
    return 1
  fi
}

