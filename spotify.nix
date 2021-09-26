final: prev:
with prev;
let
  fetchurlHashless = args: lib.overrideDerivation
    # Use a dummy hash, to appease fetchgit's assertions
    (fetchurl (args // { sha256 = builtins.hashString "sha256" args.url; }))

    # Remove the hash-checking
    (old: {
      outputHash = null;
      outputHashAlgo = null;
      outputHashMode = null;
      sha256 = null;
    });
in
{
  spotify = stdenv.mkDerivation rec {
    pname = "Spotify";
    version = "latest";

    buildInputs = [ undmg ];
    phases = [ "unpackPhase" "installPhase" ];
    sourceRoot = "Spotify.app";
    installPhase = ''
      mkdir -p "$out/Applications/Spotify.app"
      cp -r "Contents" "$out/Applications/Spotify.app/Contents"
    '';

    # TODO: This is a hack, so we don't have to update the sha every time a new
    # version is uploaded (note that the url does not contain a version)
    src = fetchurlHashless {
      name = "Spotify.dmg";
      url = "https://download.scdn.co/Spotify.dmg";
    };

    meta = {
      description = "Spotify";
      homepage = "https://www.spotify.com/";
      platforms = lib.platforms.darwin;
    };
  };
}
