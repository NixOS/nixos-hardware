{ config, lib, ... }: {
  imports = [
    ../.
    ../../../common/cpu/intel
    ../../../common/pc/laptop/acpi_call.nix
    ../../../common/pc/laptop/ssd
  ];

  # automatic screen orientation
  hardware.sensor.iio.enable = true;

  services.xserver.wacom.enable = lib.mkDefault config.services.xserver.enable;
}
