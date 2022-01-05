{stdenv, lib, pkgs, firmwareLinuxNonfree, ...}:
let
  repos = (pkgs.callPackage ../../../repos.nix {});
  killernetworking_firmware = repos.surface-go-ath10k-firmware_backup + "/K1535_Debian";
in
firmwareLinuxNonfree.overrideAttrs (old: rec {
  pname = "microsoft-surface-go-firmware-linux-nonfree";
  srcs = [
    firmwareLinuxNonfree.src
    killernetworking_firmware
  ];
  sourceRoot = firmwareLinuxNonfree.src;

  dontMakeSourcesWritable = true;
  postInstall = ''
    # Delete the non-working firmware:
    rm -v $out/lib/firmware/ath10k/QCA6174/{hw2.1,hw3.0}/board.bin
    rm -v $out/lib/firmware/ath10k/QCA6174/{hw2.1,hw3.0}/board-2.bin

    # Install the Surface Go Wifi firmware:
    cp ${killernetworking_firmware}/board.bin $out/lib/firmware/ath10k/QCA6174/hw2.1/
    cp ${killernetworking_firmware}/board.bin $out/lib/firmware/ath10k/QCA6174/hw3.0/
  '';

  outputHash = "sha256-UD0LzWOiLnlrNeiDyvqWq0FuNe5wjMNaV+hKHZLWzzk=";

  meta = with lib; {
    description = "Standard binary firmware collection, adjusted with the Surface Go WiFi firmware";
    platforms = platforms.linux;
    priority = 5;
  };
})
