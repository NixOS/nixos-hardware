{ lib, config, ... }:
{
  imports = [
    ../.
    ../../../common/pc/laptop/ssd
    ../../../common/cpu/intel/haswell
  ];

  # broadcom-wl
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  boot.extraModulePackages = with config.boot.kernelPackages; [ broadcom_sta ];
  boot.kernelModules = [ "wl" ];
}
