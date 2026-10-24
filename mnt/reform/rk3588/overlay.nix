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

  mpv-unwrapped =
    (prev.mpv-unwrapped.overrideAttrs {
      src = prev.fetchFromGitHub {
        owner = "philipl";
        repo = "mpv";
        rev = "beb3771179b45096702c0b15704bf5b0ca5f9d61";
        hash = "sha256-ccsWXSApJZgQnjEXTSyWLK4OsYE3LvhRK4t9bSnk3I0=";
      };
    }).override
      {
        ffmpeg = final.ffmpeg-rk3588;
      };
}
