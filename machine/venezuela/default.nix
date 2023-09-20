{ pkgs, ... }:
let
  sdks = with pkgs.dotnetCorePackages;
    combinePackages [
      sdk_7_0
      sdk_6_0
    ];
in
{
  imports = [
    ../../common-dev-tools.nix
    ../../karabiner
  ];

  targets.darwin.defaults = {
    "com.apple.dock" = {
      # Changes here requires "killall Dock" to be run after switching
      expose-group-apps = true;
      autohide = true;
      static-only = true;
    };
  };

  home.sessionVariables = {
    DOTNET_ROOT = "${sdks}";
  };

  home.shellAliases = {
    bin2ulid="${pkgs.python3}/bin/python3 -c 'y = int(input().strip(),16); print(\"\".join(reversed([\"0123456789ABCDEFGHJKMNPQRSTVWXYZ\"[(y >> 5*i )& 31] for i in range(26)])))'";

    ulid2bin="${pkgs.python3}/bin/python3 -c 'print(hex(sum(e << i*5 for i, e in enumerate(reversed([\"0123456789ABCDEFGHJKMNPQRSTVWXYZ\".index(c) for c in input().strip().upper()])))))'";
  };

  home.packages = with pkgs; [
    go
    gopls
    delve
    go-bindata
    sdks
    yarn
    slack-cli
    k6
    kubelogin
    dbeaver
  ];
}
