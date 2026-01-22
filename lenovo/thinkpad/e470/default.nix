{ lib, pkgs, ... }:

{
  imports = [
    ../.
    ../../../common/cpu/intel/kaby-lake
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/gpu/nvidia/maxwell
  ];

  hardware.nvidia.prime = {
    # Bus ID of the Intel GPU.
    intelBusId = lib.mkDefault "PCI:0:2:0";

    # Bus ID of the NVIDIA GPU.
    nvidiaBusId = lib.mkDefault "PCI:1:0:0";
  };

  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.6") pkgs.linuxPackages_latest;
}
