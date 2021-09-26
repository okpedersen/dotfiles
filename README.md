# dotfiles

Dotfiles using nix, nix flakes and home-manager.

## Setup

### Clone dotfiles

```bash
git clone https://github.com/okpedersen/dotfiles
cd dotfiles
```

### Install nix

The dotfiles needs a nix 2.4 prerelease (nix unstable) to work with nix flakes. Getting it setup can be done by running

```bash
./bootstrap-nix.sh
```

**Note**: This setup assumes `flake.nix` is configured correctly for the user running the command.

## Nice-to-know commands

* Update flake inputs in lock file: `nix flake update`
* Update a single flake input in lock file (e.g., `home-manager`): `nix flake lock --update-input home-manager`

## License

The software is licensed under the MIT License. Please see [LICENSE](LICENSE)
