{ config, lib, pkgs, ... }:

{
  imports = [
    ../.
    ../../../../common/cpu/amd
  ];

  boot.kernelParams = [
    # With BIOS version 1.12 and the IOMMU enabled, the amdgpu driver
    # either crashes or is not able to attach to the GPU depending on
    # the kernel version. I've seen no issues with the IOMMU disabled.
    "iommu=off"
  ];

  # As of writing this, Linux 5.8 is the oldest kernel that is still
  # supported and has decent Renoir support.
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.8") pkgs.linuxPackages_latest;
}
