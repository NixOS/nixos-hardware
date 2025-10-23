{ pkgs, ... }:
with pkgs;
stdenv.mkDerivation rec {
  pname = "comms-sbc-firmware";
  version = "v0_6.36";

  src = builtins.fetchGit {
    url = "git@github.com:tiiuae/comms-sbc-firmware.git";
    rev = "06394d6d983955734257fdc7f719e454a3ce07f4";
  };

  nativeBuildInputs = [
    pkgs.rsync
    pkgs.coreutils
  ];
  dontUnpack = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out
    # copy everything except .git
    rsync -a --exclude='.git' $src/ $out/
  '';
}
