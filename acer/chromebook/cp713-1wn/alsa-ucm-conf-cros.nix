{ lib
, alsa-ucm-conf
, fetchFromGitHub
}:

alsa-ucm-conf.overrideAttrs (oldAttrs: {
  wttsrc = fetchFromGitHub {
    owner = "WeirdTreeThing";
    repo = "alsa-ucm-conf-cros";
    rev = "1908a457c7f2bf8b63264fe3b1e0522ea632ac5a";
    hash = "sha256-h4qphJgXlEGMjpV4+llTaJeM3hoglmmgkXY8rOp+MAI=";
  };

  postInstall = ''
    cp -rf $wttsrc/ucm2 $out/share/alsa/
  '';

  meta = oldAttrs.meta // {
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
})

