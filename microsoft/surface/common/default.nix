{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkDefault
    mkOption
    types
    ;

  kernelPackages = pkgs.callPackage ../pkgs/kernel {
    inherit (config.hardware.microsoft-surface) kernelVersion;
  };

in
{
  options.hardware.microsoft-surface.kernelVersion = mkOption {
    description = "Kernel Version to use (patched for MS Surface)";
    type = types.enum [
      "longterm"
      "stable"
    ];
    default = "longterm";
  };

  config = {
    boot = {
      inherit kernelPackages;

      # Seems to be required to properly enable S0ix "Modern Standby":
      kernelParams = mkDefault [ "mem_sleep_default=deep" ];
    };

    # NOTE: Check the README before enabling TLP:
    services.tlp.enable = mkDefault false;

    # Needed for wifi firmware, see https://github.com/NixOS/nixos-hardware/issues/364
    hardware = {
      enableRedistributableFirmware = mkDefault true;
      sensor.iio.enable = mkDefault true;
    };
  };
}
