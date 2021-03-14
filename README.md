# dotfiles

My dotfiles. Setup is not thoroughly tested on non-macOS environments.

## WSL

Follow instructions to install WSL here: https://docs.microsoft.com/en-us/windows/wsl/install-win10

## All

Clone dotfiles:

```
git clone https://github.com/okpedersen/dotfiles
cd dotfiles
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

Add system specific variables in `home-config.nix`, e.g.:

```
{ ... }:
{
  homeUsername = "<username>";
  homeHomeDirectory = "</path/to/home/directory>";
  gitUserEmail = "default-email-for-git@machine";
}
```

Define `home.nix`, typically only import the correct machine config:

```
{ ... }:
{
  imports = [
    ./machine/belgium
  ];
}
```

Run `install.sh`:

```
./install.sh
```

## License

The software is licensed under the MIT License. Please see [LICENSE](LICENSE)
