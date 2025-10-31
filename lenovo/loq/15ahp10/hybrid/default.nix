{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../../../../common/cpu/amd
    ../../../../common/gpu/amd
    ../../../../common/gpu/nvidia
    ../../../../common/gpu/nvidia/blackwell
    ../../../../common/gpu/nvidia/prime.nix
    ../../../../common/pc/laptop
    ../../../../common/pc/ssd
  ];

  hardware.nvidia = {
    modesetting.enable = lib.mkDefault true;
    open = lib.mkDefault true;
    powerManagement = {
      enable = lib.mkDefault true;
      finegrained = lib.mkDefault true;
    };
    prime = {
      amdgpuBusId = "PCI:6:0:0"; # 06:00.0 in hexadecimal -> 6:0:0 in decimal
      nvidiaBusId = "PCI:1:0:0"; # 01:00.0 in hexadecimal -> 1:0:0 in decimal
    };
  };

  # AMD has better battery life with PPD over TLP:
  # https://community.frame.work/t/responded-amd-7040-sleep-states/38101/13
  services.power-profiles-daemon.enable = lib.mkDefault true;
}
