# Motherboard: ROG STRIX X570-E GAMING
{ ... }:

{
  imports = [
    ../../../common/cpu/amd
    ../../../common/cpu/amd/pstate.nix
    ../../../common/cpu/amd/zenpower.nix
    ../../../common/pc/ssd
  ];

  boot.kernelModules = [
    "btintel" # Bluetooth driver for Intel AX200 802.11ax
    "nct6775" # Temperature and Fan Sensor for Nuvoton NCT6798D-R
  ];
}
