{ lib
, fetchFromGitHub
, buildUBoot
, buildPackages
, opensbi
}:

buildUBoot rec {
  version = "2024.01-rc5";

  src = fetchFromGitHub {
    owner = "u-boot";
    repo = "u-boot";
    rev = "refs/tags/v${version}";
    hash = "sha256-QlwgvnSaXh39z9AM7HNF731lRiUkPbN3oQyioQNTYFA=";
  };

  # workaround for https://github.com/NixOS/nixpkgs/pull/146634
  # uboot: only apply raspberry pi patches to raspberry pi builds
  patches = [ ];

  extraMakeFlags = [
    # workaround for https://github.com/NixOS/nixpkgs/pull/277997
    # buildUBoot: specify absolute path of dtc, fix building u-boot 2023.10+
    "DTC=${lib.getExe buildPackages.dtc}"

    "OPENSBI=${opensbi}/share/opensbi/lp64/generic/firmware/fw_dynamic.bin"
  ];

  defconfig = "starfive_visionfive2_defconfig";

  filesToInstall = [
    "spl/u-boot-spl.bin.normal.out"
    "u-boot.itb"
  ];
}
