{stdenv, pkgs, firmwareLinuxNonfree, ...}:
let
  repos = (pkgs.callPackage ../repos.nix {});
in

firmwareLinuxNonfree.overrideAttrs (old: rec {
  pname = "microsoft-surface-go-firmware-linux-nonfree";
  srcs = [
    firmwareLinuxNonfree.src
    repos.ath10k-firmware
  ];

  sourceRoot = firmwareLinuxNonfree.src;
  priority = 1;

  dontMakeSourcesWritable = true;
  postInstall = ''
    # rm -v $out/lib/firmware/ath10k/{hw2.1,hw3.0}/board.bin
    # rm -v $out/lib/firmware/ath10k/{hw2.1,hw3.0}/board2.bin

    # cp $srcs[1] $out/lib/firmware/ath10k/hw2.1/
    # cp $srcs[1] $out/lib/firmware/ath10k/hw3.0/

    #TODO:
    pwd
    echo src = $src, srcs = $srcs
    exit 1
  '';
})
