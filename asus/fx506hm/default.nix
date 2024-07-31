{ config, lib, ... }:

{
  imports =
  [
    ../../common/cpu/intel
    ../../common/gpu/nvidia
    ../../common/gpu/nvidia/prime.nix
    ../../common/pc/laptop
    ../../common/pc/ssd
    ../battery.nix
  ];

  hardware.nvidia =
  {
    modesetting.enable = lib.mkDefault true;
    open = lib.mkIf (lib.versionAtLeast config.hardware.nvidia.package.version "555") true;

    prime =
    {
      intelBusId  = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
