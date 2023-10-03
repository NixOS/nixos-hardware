{ lib
, buildLinux
, fetchFromGitLab
, ...
} @ args:
buildLinux (args
  // rec {
  defconfig = "librem5_defconfig";
  version = "6.5.4-librem5";
  modDirVersion = version;
  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = "linux";
    rev = "pureos/6.5.4pureos1";
    hash = "sha256-wPosmPiQiaODfxlxNA/PGqOIBKlEcO+pOPvdZn7R9T0=";
  };
  kernelPatches = [ ];
  structuredExtraConfig = with lib.kernel; {
    # buildLinux overrides this and defaults to 32, so go back to the value defined librem5_defconfig
    # this is required for millipixels to take photos, otherwise the VIDIOC_REQ_BUFS ioctl returns ENOMEM
    CMA_SIZE_MBYTES = lib.mkForce (freeform "320");
  };
}
  // args.argsOverride or { })
