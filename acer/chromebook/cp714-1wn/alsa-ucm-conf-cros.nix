{
  alsa-ucm-conf,
  fetchFromGitHub,
}:

alsa-ucm-conf.overrideAttrs (oldAttrs: {
  crosSrc = fetchFromGitHub {
    owner = "WeirdTreeThing";
    repo = "alsa-ucm-conf-cros";
    rev = "a4e92135fd49e669b5ce096439289e05e25ae90c";
    hash = "sha256-3TpzjmWuOn8+eIdj0BUQk2TeAU7BzPBi3FxAmZ3zkN8=";
  };

  postInstall = ''
    cp -rf $crosSrc/ucm2 $out/share/alsa/

    mkdir -p $out/share/alsa/ucm2/sof-nau8825
    cp $crosSrc/ucm2/conf.d/sof-nau8825/HiFi.conf $out/share/alsa/ucm2/sof-nau8825/
    cp $crosSrc/ucm2/conf.d/sof-nau8825/sof-nau8825.conf $out/share/alsa/ucm2/sof-nau8825/
  '';

  meta = oldAttrs.meta // {
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
})
