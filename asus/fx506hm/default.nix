{ lib, ... }:

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

    prime =
    {
      intelBusId  = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
