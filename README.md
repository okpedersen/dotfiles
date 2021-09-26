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

**Note**: This setup assumes `flake.nix` is configured correctly for the user running the command. Add the `--no-switch` flag to not build and activate the
home-manager config. `nix run .#belgium switch` or similar should then be run manually to get the desired config up and running.

## Nice-to-know commands

* Build the default home-manager configuration for the current user: `home-manager build`
* Build and activate the default home-manager configuration for the current user: `home-manager switch`
* Build a given home-manager config (e.g., `belgium`): `nix run .#belgium build`
* Build and activate a given home-manager config (e.g., `belgium`): `nix run .#belgium switch`
* Update flake inputs in lock file: `nix flake update`
* Update a single flake input in lock file (e.g., `home-manager`): `nix flake lock --update-input home-manager`
* Format all nix files: `nixpkgs-fmt **/*.nix`

## License

The software is licensed under the MIT License. Please see [LICENSE](LICENSE)
