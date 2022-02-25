{stdenv, lib, pkgs, firmwareLinuxNonfree, ...}:
let
  repos = (pkgs.callPackage ../../../repos.nix {});
  killernetworking_firmware = repos.surface-go-ath10k-firmware_backup + "/K1535_Debian";
in
stdenv.mkDerivation {
  pname = "microsoft-surface-go-firmware-linux-nonfree";
  inherit (firmwareLinuxNonfree) version;
  src = firmwareLinuxNonfree;
  phases = [ "unpackPhase" "installPhase" ];

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
