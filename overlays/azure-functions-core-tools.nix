self: super: {
  azure-functions-core-tools = super.azure-functions-core-tools.overrideAttrs (
    o: rec {
      pname = "azure-functions-core-tools";
      version = "4.0.4670";

      src = super.fetchurl {
        url = "https://github.com/Azure/${pname}/releases/download/${version}/Azure.Functions.Cli.osx-x64.${version}.zip";
        sha256 = "OSwbOfXHX6iZzncg9yUMPnmWue5kvGZY5eu+gXt1ZBM=";
      };

      installPhase = ''
        mkdir -p $out/bin $out/.bin
        cp -prd * $out/.bin
        chmod +x $out/.bin/func $out/.bin/gozip
        ln -s $out/{.,}bin/func
        ln -s $out/{.,}bin/gozip
      '';

      meta.platforms = super.lib.platforms.darwin;
    }
  );
}
