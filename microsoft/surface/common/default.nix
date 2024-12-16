{ lib, ... }:

let
  inherit (lib) mkDefault;

in {
  imports = [
    ./kernel
  ];

  microsoft-surface.kernelVersion = mkDefault "6.12";

  # Seems to be required to properly enable S0ix "Modern Standby":
  boot.kernelParams = mkDefault [ "mem_sleep_default=deep" ];

  # NOTE: Check the README before enabling TLP:
  services.tlp.enable = mkDefault false;

  # i.e. needed for wifi firmware, see https://github.com/NixOS/nixos-hardware/issues/364
  hardware.enableRedistributableFirmware = mkDefault true;
  hardware.sensor.iio.enable = mkDefault true;
}
