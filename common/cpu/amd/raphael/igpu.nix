{ lib, pkgs, ... }: 

{
  # Disables scatter/gather which was introduced with kernel version 6.2
  # It produces completely white or flashing screens when enabled while using the iGPU of Ryzen 7000-series CPUs (Raphael)

  imports = [ ../. ];

  boot = lib.mkMerge [
    (lib.mkIf (lib.versionOlder pkgs.linux.version "6.1") {
      kernelPackages = pkgs.linuxPackages_latest;
      kernelParams = lib.mkMerge [["amdgpu.sg_display=0"]];  
    })
  ];
}
