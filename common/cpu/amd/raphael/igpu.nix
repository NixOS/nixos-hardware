{
  lib,
  pkgs,
  config,
  ...
}:

{
  # Sets the kernel version to the latest kernel to make the usage of the iGPU possible if your kernel version is too old
  # Disables scatter/gather which was introduced with kernel version 6.2
  # It produces completely white or flashing screens when enabled while using the iGPU of Ryzen 7000-series CPUs (Raphael)
  # This issue is not seen in kernel 6.6 or newer versions

  imports = [ ../. ];

  boot = lib.mkMerge [
    (lib.mkIf (lib.versionOlder pkgs.linux.version "6.1") {
      kernelPackages = pkgs.linuxPackages_latest;
    })

    (lib.mkIf (
      (lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.2")
      && (lib.versionOlder config.boot.kernelPackages.kernel.version "6.6")
    ) { kernelParams = [ "amdgpu.sg_display=0" ]; })
  ];
}
