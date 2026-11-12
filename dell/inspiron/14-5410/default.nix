{
  lib,
  ...
}:
{
  imports = [
    ../../../common/cpu/intel/tiger-lake/cpu-only.nix
    ../../../common/gpu/intel/tiger-lake
    ../../../common/pc/laptop
    ../../../common/pc/ssd
    ../../../common/hidpi.nix
  ];

  config = {
    hardware.enableRedistributableFirmware = lib.mkDefault true;

    services.fwupd.enable = lib.mkDefault true;
    services.thermald.enable = lib.mkDefault true;
  };
}
