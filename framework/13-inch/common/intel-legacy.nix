{ config, lib, ... }: {
  # on intel 11-13th gen, enable kmod by default if
  # - kernel >= 6.10
  # - nixos >= 24.05
  hardware.framework.enableKmod =
    lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.10" &&
    lib.versionAtLeast (lib.versions.majorMinor lib.version) "24.05";
}
