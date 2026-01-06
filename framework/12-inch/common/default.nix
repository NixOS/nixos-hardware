{ lib, config, ... }:
{
  imports = [
    ../../../common/pc/laptop
    ../../../common/pc/ssd
    ../../bluetooth.nix
    ../../kmod.nix
    ../../framework-tool.nix
  ];

  # Fix TRRS headphones missing a mic
  # https://github.com/torvalds/linux/commit/7b509910b3ad6d7aacead24c8744de10daf8715d
  boot.extraModprobeConfig = lib.mkIf (lib.versionOlder config.boot.kernelPackages.kernel.version "6.13.0") ''
    options snd-hda-intel model=dell-headset-multi
  '';

  # Needed for desktop environments to detect display orientation
  hardware.sensor.iio.enable = lib.mkDefault true;

  # Everything is updateable through fwupd
  services.fwupd.enable = true;
}
