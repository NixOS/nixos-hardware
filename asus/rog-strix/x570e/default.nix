# Motherboard: ROG STRIX X570-E GAMING
{ ... }:

{
  imports = [
    ../../../common/cpu/amd
    ../../../common/cpu/amd/pstate.nix
    ../../../common/cpu/amd/zenpower.nix
    ../../../common/pc/ssd
  ];

  # Bluetooth driver for Intel AX200 802.11ax
  boot.kernelModules = [ "btintel" ];
}
