{ lib, pkgs, ... }: {
  imports = [
    ../../../common/pc/laptop/ssd
    ./audio.nix
  ];

  # For fingerprint support
  services.fprintd.enable = lib.mkDefault true;

  # Needed for desktop environments to detect/manage display brightness
  hardware.sensor.iio.enable = lib.mkDefault true;
}
