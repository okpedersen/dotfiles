self: super: {
  azure-functions-core-tools = super.azure-functions-core-tools.overrideAttrs (
    o: rec {
      pname = "azure-functions-core-tools";
      version = "3.0.3785";

      src = super.fetchurl {
        url = "https://github.com/Azure/${pname}/releases/download/${version}/Azure.Functions.Cli.osx-x64.${version}.zip";
        sha256 = "09x579aq85z2x068zi9h028iy57am6v2q0f4pbkyadm3n933ayw5";
      };

      installPhase = ''
        mkdir -p $out/bin
        cp -prd * $out/bin 
        chmod +x $out/bin/func $out/bin/gozip
      '';

      meta.platforms = super.lib.platforms.darwin;
    }
  );
}
