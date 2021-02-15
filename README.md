# dotfiles

Tested on WSL2 and macOS.

## WSL

Follow instructions to install WSL here: https://docs.microsoft.com/en-us/windows/wsl/install-win10

## All

Clone dotfiles and run `install.sh`:

```
git clone https://github.com/okpedersen/dotfiles
cd dotfiles
./install.sh
```

Install nix:

Follow the instructions here: [https://nixos.org/manual/nix/stable/#chap-installation](https://nixos.org/manual/nix/stable/#chap-installation).

 * For macOS: `sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume`

Install home-manager:

Follow [https://github.com/nix-community/home-manager#installation](https://github.com/nix-community/home-manager#installation). Probably something like:

```
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```

## License

The software is licensed under the MIT License. Please see [LICENSE](LICENSE)
