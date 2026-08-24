{ lib, ... }:

{
  imports = [
    ../../../common/cpu/amd
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/amd
    ../../../common/pc/laptop
    ../../../common/pc/ssd
    ../../../common/hidpi.nix
    ../../battery.nix
  ];

  hardware.enableRedistributableFirmware = lib.mkDefault true;
  security.tpm2.enable = lib.mkDefault true;
  hardware.sensor.iio.enable = lib.mkDefault true;
}
