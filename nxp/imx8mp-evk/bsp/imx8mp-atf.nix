{
  lib,
  pkgs,
  buildArmTrustedFirmware,
  fetchgit,
  enable-tee,
}:
with pkgs; let
  opteedflag =
    if enable-tee
    then "SPD=opteed"
    else "";
  target-board = "imx8mp";
in
  buildArmTrustedFirmware rec {
    pname = "imx8mp-atf";
    platform = target-board;
    enableParallelBuilding = true;
    extraMeta.platforms = ["aarch64-linux"];

    src = fetchgit {
      url = "https://github.com/nxp-imx/imx-atf.git";
      #lf6.1.55_2.2.0
      rev = "08e9d4eef2262c0dd072b4325e8919e06d349e02";
      sha256 = "sha256-96EddJXlFEkP/LIGVgNBvUP4IDI3BbDE/c9Yub22gnc=";
    };

    makeFlags = [ 
      "HOSTCC=$(CC_FOR_BUILD)"
      "M0_CROSS_COMPILE=arm-none-eabi-"
      "CROSS_COMPILE=aarch64-unknown-linux-gnu-"
      # binutils 2.39 regression
      # `warning: /build/source/build/rk3399/release/bl31/bl31.elf has a LOAD segment with RWX permissions`
      # See also: https://developer.trustedfirmware.org/T996
      "LDFLAGS=-no-warn-rwx-segments"
      "PLAT=${platform}" "bl31" "${opteedflag}"
    ];  

    filesToInstall = ["build/${target-board}/release/bl31.bin"];
  }
