{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../.
    ../../common/gpu/nvidia/prime.nix
    ../../common/gpu/nvidia/ampere
    ../../common/cpu/intel/raptor-lake
    ../../common/pc/laptop
    ../../common/pc/ssd
  ];

  # For offloading, `modesetting` is needed
  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];

  hardware.graphics = {
    enable = lib.mkDefault true;
    enable32Bit = lib.mkDefault true;
  };

  hardware.nvidia = {

    powerManagement.finegrained = lib.mkDefault true;

    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
