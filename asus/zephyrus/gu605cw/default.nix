{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/gpu/nvidia/blackwell
    ../../../common/pc/laptop
    ../../../common/pc/ssd
    ../shared/backlight.nix
  ];

  hardware.nvidia = {
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    modesetting.enable = lib.mkDefault true;
    dynamicBoost.enable = lib.mkDefault true;
  };

  services = {
    asusd.enable = lib.mkDefault true;
  };

  services.tuned.enable = true;
  services.tlp.enable = lib.mkOverride 500 false;
}
