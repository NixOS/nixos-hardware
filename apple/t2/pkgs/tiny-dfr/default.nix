{
  lib,
  rustPlatform,
  fetchFromGitHub,

  pkg-config,
  cairo,
  gdk-pixbuf,
  glib,
  libinput,
  libxml2,
  pango,
  udev,
}:
let
  src = fetchFromGitHub {
    owner = "kekrby";
    repo = "tiny-dfr";
    rev = "8a5d413cb1dbe2a25b77a9e7f3cb5b9c88ef3ffb";
    hash = "sha256-l4D7aePz/CYpkRorrvsgIYrvSzoZl59OGcFGJqqJftk=";
  };
in rustPlatform.buildRustPackage {
  pname = "tiny-dfr";
  version = src.rev;

  inherit src;

  cargoLock.lockFile = ./Cargo.lock;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    udev
    glib
    pango
    cairo
    gdk-pixbuf
    libxml2
    libinput
  ];

  postPatch = ''
    substituteInPlace src/main.rs \
      --replace-fail "/usr/share/tiny-dfr/" "$out/share/tiny-dfr/"
  '';

  postInstall = ''
    mkdir -p $out/etc $out/share

    cp -r etc/udev $out/etc/
    cp -r share/tiny-dfr $out/share/
  '';

  meta = with lib; {
    description = "The most basic dynamic function row daemon possible";
    homepage = "https://github.com/kekrby/tiny-dfr";
    license = with licenses; [ asl20 bsd3 cc0 isc lgpl21Plus mit mpl20 unicode-dfs-2016 asl20 asl20-llvm mit unlicense ];
    maintainers = [];
  };
}
