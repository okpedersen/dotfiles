self: super: {
  omnisharp-roslyn = super.omnisharp-roslyn.overrideAttrs (
    o: {
      meta.plattform = super.lib.platforms.unix;
    }
  );
}
