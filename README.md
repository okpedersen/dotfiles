# dotfiles

Dotfiles using nix, nix flakes and home-manager.

## Setup

### Clone dotfiles

```bash
git clone https://github.com/okpedersen/dotfiles
cd dotfiles
```

### Install nix

Using the [Determinate Nix Installer](https://zero-to-nix.com/concepts/nix-installer) simplifies getting everything setup, including flakes and the new CLI. Using the command from the docs:

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Assuming `flake.nix` is correctly configured for the current system (including host and user), the following command run from the current directory should set up the system correctly for the first time:

```bash
nix run nix-darwin -- switch --flake .
```


## Nice-to-know commands

* Build the default home-manager configuration for the current user: `darwin-rebuild build --flake .`
* Build and activate the default home-manager configuration for the current user: `darwin-rebuild switch --flake .`
* Update flake inputs in lock file: `nix flake update`
* Update a single flake input in lock file (e.g., `home-manager`): `nix flake lock --update-input home-manager`
* Format all nix files: `nixpkgs-fmt **/*.nix`

## License

The software is licensed under the MIT License. Please see [LICENSE](LICENSE)
