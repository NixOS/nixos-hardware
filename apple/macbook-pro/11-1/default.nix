{ lib, config, ... }:
{
  imports = [
    ../.
    ../../../common/pc/laptop/ssd
    ../../../common/cpu/intel/haswell
  ];

  # broadcom-wl
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  # nixos-generate-config doesn't detect this automatically.
  boot.extraModulePackages = with config.boot.kernelPackages; [ broadcom_sta ];
  boot.kernelModules = [ "wl" ];
}
