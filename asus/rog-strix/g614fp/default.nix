{ pkgs, lib, ... }:
{
  imports = [
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/gpu/nvidia/blackwell
    ../../../common/pc/laptop
    ../../../common/pc/ssd
    ../../battery.nix
    ../../../common/wifi/mediatek/mt7925
  ];

  hardware.nvidia = {
    prime = {
      amdgpuBusId = "PCI:105:0:0";
      nvidiaBusId = "PCI:1:0:1";
    };
    dynamicBoost.enable = lib.mkDefault true;
  };

  services = {
    asusd.enable = lib.mkDefault true;
  };

  boot.kernelParams = [
    #See readme - resolves slow boot
    "gpiolib_acpi.run_edge_events_on_boot=0"
  ];
}
