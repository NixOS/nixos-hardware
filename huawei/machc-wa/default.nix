{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ../../common/cpu/intel/comet-lake
    ../../common/gpu/intel/comet-lake
    ../../common/gpu/nvidia/pascal
    ../../common/gpu/nvidia/prime.nix
    ../../common/pc/laptop
    ../../common/pc/ssd
  ];

  hardware.nvidia = {
    modesetting.enable = lib.mkDefault true;
    nvidiaSettings = lib.mkDefault true;
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
