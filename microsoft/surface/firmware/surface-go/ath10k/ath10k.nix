{stdenv, lib, pkgs, firmwareLinuxNonfree, ...}:
let
  repos = (pkgs.callPackage ../../../repos.nix {});
  # killernetworking_firmware = ./K1535_Debian;
  killernetworking_firmware = repos.ath10k-firmware + "/K1535_Debian";
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

  outputHash = "1nc56qii96dfvxnv3ad3lxz2rzyqcbldk0h9rbm3l2pgamkvj8dw";

  meta = with lib; {
    description = "Standard binary firmware collection, adjusted with the Surface Go WiFi firmware";
    platforms = platforms.linux;
    priority = 5;
  };
})
