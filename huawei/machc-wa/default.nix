{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ../../common/cpu/intel/comet-lake
    ../../common/gpu/nvidia
    ../../common/gpu/nvidia/prime.nix
    ../../common/hidpi.nix
    ../../common/pc/laptop
    ../../common/pc/ssd
  ];

  hardware.nvidia = {
    modesetting.enable = lib.mkDefault true;
    open = lib.mkDefault false;
    nvidiaSettings = lib.mkDefault true;
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  services.power-profiles-daemon.enable = lib.mkDefault true;
}
