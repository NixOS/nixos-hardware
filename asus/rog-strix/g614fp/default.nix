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
      #These values were correct out the box. After installing a second SSD the amdgpuBusId became
      #"PCI:106:0:0". This value can be obtained from "lspci" (but should be converted from hex to dec)
      amdgpuBusId = lib.mkDefault "PCI:105:0:0";
      nvidiaBusId = lib.mkDefault "PCI:1:0:1";
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
