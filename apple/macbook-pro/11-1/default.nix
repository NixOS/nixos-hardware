{ lib, config, ... }:
{
  imports = [
    ../.
    ../../../common/pc/ssd
    ../../../common/cpu/intel/haswell
    ../../../common/broadcom-wifi.nix
  ];

  config = {
    hardware.enableRedistributableFirmware = lib.mkDefault true; # broadcom-wl
  };
}
