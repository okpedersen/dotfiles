SOURCE_NIX_DAEMON_SCRIPT="if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'; fi"

echo "$SOURCE_NIX_DAEMON_SCRIPT" | sudo tee -a /etc/zshrc
