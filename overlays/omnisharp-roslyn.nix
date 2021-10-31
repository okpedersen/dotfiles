self: super: {
  omnisharp-roslyn = super.stdenv.mkDerivation rec {
    pname = "omnisharp-roslyn";
    version = "1.37.16";

    src = builtins.fetchurl {
      url = "https://github.com/Omnisharp/omnisharp-roslyn/releases/download/v${version}/omnisharp-osx.zip";
      sha256 = "0hhgfx7zs1rljhn3n9c7lci7j15yp2448z3f1d3c47a95l1hmlip";
    };

    buildInputs = [ super.unzip ];
    nativeBuildInputs = [ super.makeWrapper ];
    phases = [ "unpackPhase" "installPhase" ];
    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out
      cp -R . $out/omnisharp-roslyn
      chmod a+x $out/omnisharp-roslyn/run
      makeWrapper $out/omnisharp-roslyn/run \
        $out/bin/omnisharp-roslyn
    '';

    meta = {
      description = "omnisharp-roslyn";
      homepage = "https://github.com/OmniSharp/omnisharp-roslyn";
      platforms = super.lib.platforms.darwin;
    };
  };
}
