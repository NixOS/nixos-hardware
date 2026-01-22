{
  buildArmTrustedFirmware,
  targetBoard,
  fetchgit,
}:

{
  armTrustedFirmwareiMX8 = buildArmTrustedFirmware rec {
    src = fetchgit {
      url = "https://github.com/nxp-imx/imx-atf.git";
      # tag: "lf_v2.6"
      rev = "c6a19b1a351308cc73443283f6aa56b2eff791b8";
      sha256 = "sha256-C046MrZBDFuzBdnjuPC2fAGtXzZjTWRrO8nYTf1rjeg=";
    };
    platform = targetBoard;
    enableParallelBuilding = true;
    # To build with tee.bin use extraMakeFlags = [ "bl31 SPD=opteed" ];
    extraMakeFlags = [
      "PIE_LDFLAGS=--no-warn-rwx-segments LDFLAGS=--no-warn-rwx-segments"
      "bl31"
    ];
    extraMeta.platforms = [ "aarch64-linux" ];
    filesToInstall = [ "build/${targetBoard}/release/bl31.bin" ];
  };
}
