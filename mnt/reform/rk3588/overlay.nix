final: prev: {
  ffmpeg-rk3588 = prev.ffmpeg_8.overrideAttrs (attrs: {
    src = prev.fetchFromGitHub {
      owner = "Kwiboo";
      repo = "FFmpeg";
      rev = "b57fbbe50c9b2656fad86a1a7eeabfd2b2a50935";
      hash = "sha256-+4PV7b3EdgYW3VX9dIPhK/pCgiVlC84RkJzSYTE4QKA=";
    };
    configureFlags = attrs.configureFlags ++ [
      "--enable-v4l2-request"
      "--enable-libudev"
    ];
    buildInputs = attrs.buildInputs ++ [ prev.udev ];
  });

  mpv-unwrapped = prev.callPackage ./mpv.nix { ffmpeg = final.ffmpeg-rk3588; };
}
