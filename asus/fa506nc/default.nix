{ lib, ... }:

{
  imports = [
    ../../common/cpu/amd
    ../../common/cpu/amd/pstate.nix
    ../../common/gpu/amd
    ../../common/gpu/nvidia/prime.nix
    ../../common/gpu/nvidia/ampere
    ../../common/pc/laptop
    ../../common/pc/ssd
  ];

  hardware.nvidia = {
    dynamicBoost.enable = lib.mkDefault true;

    prime = {
      amdgpuBusId = "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # AMD has better battery life with PPD over TLP:
  # https://community.frame.work/t/responded-amd-7040-sleep-states/38101/13
  services.power-profiles-daemon.enable = lib.mkDefault true;

  services = {
    # https://asus-linux.org/manual/asusctl-manual/
    asusd.enable = lib.mkDefault true;
    supergfxd.enable = lib.mkDefault true;
  };
}
