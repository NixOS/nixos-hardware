{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../../../common/cpu/intel/raptor-lake
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/gpu/nvidia/ada-lovelace
    ../../../common/pc/laptop
    ../../../common/pc/ssd
    ../../../common/hidpi.nix
  ];

  # Requires at least 6.13 for correct audio behaviour.
  # https://github.com/torvalds/linux/commit/34c8e74cd6667ef5da90d448a1af702c4b873bd3
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.13") (
    lib.mkDefault pkgs.linuxPackages_latest
  );

  # Ambient light sensor
  hardware.sensor.iio.enable = lib.mkDefault true;
  # Fingerprint reader
  services.fprintd.enable = lib.mkDefault true;

  hardware = {
    nvidia = {
      powerManagement = {
        enable = lib.mkDefault true;
        finegrained = lib.mkDefault true;
      };
      dynamicBoost.enable = lib.mkDefault true;

      prime = {
        intelBusId = lib.mkDefault "PCI:00:02:0";
        nvidiaBusId = lib.mkDefault "PCI:01:00:0";
      };
    };
  };

  # Cooling management
  services.thermald.enable = lib.mkDefault true;

  # round(sqrt(3200^2 + 2000^2) px / 16 in) = 236 dpi
  services.xserver.dpi = 236;
}
