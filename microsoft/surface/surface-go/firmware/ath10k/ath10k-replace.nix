{
  stdenv,
  lib,
  pkgs,
  firmwareLinuxNonfree,
  ...
}:

let
  repos = pkgs.callPackage {
    surface-go-ath10k-firmware_backup = lib.fetchFromGitHub {
      owner = "mexisme";
      repo = "linux-surface_ath10k-firmware";
      rev = "74e5409e699383d6ca2bc4da4a8433d16f3850b1";
      sha256 = "169vgvxpgad9anmchs22fj5qm6ahzjfdnwhd8pc280q705vx6pjk";
    };
  } { };
  killernetworking_firmware = repos.surface-go-ath10k-firmware_backup + "/K1535_Debian";

in
stdenv.mkDerivation {
  pname = "microsoft-surface-go-firmware-linux-nonfree";
  inherit (firmwareLinuxNonfree) version;
  src = firmwareLinuxNonfree;
  phases = [
    "unpackPhase"
    "installPhase"
  ];

  installPhase = ''
    # Install the Surface Go Wifi firmware:
    cp ${killernetworking_firmware}/board.bin lib/firmware/ath10k/QCA6174/hw2.1/
    cp ${killernetworking_firmware}/board.bin lib/firmware/ath10k/QCA6174/hw3.0/

    mkdir $out; cp -r ./. $out
  '';

  meta = with lib; {
    description = "Standard binary firmware collection, adjusted with the Surface Go WiFi firmware";
    platforms = platforms.linux;
    priority = 5;
  };
}
