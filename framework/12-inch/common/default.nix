{ lib, config, ... }:
{
  imports = [
    ../../../common/pc/laptop
    ../../../common/pc/ssd
    ../../kmod.nix
    ../../framework-tool.nix
  ];

  # Fix TRRS headphones missing a mic
  # https://github.com/torvalds/linux/commit/7b509910b3ad6d7aacead24c8744de10daf8715d
  # And fix tablet mode driver loaded in the wrong order, causing tablet mode not working
  boot.extraModprobeConfig = lib.mkIf (lib.versionOlder config.boot.kernelPackages.kernel.version "6.13.0") ''
    options snd-hda-intel model=dell-headset-multi
    softdep soc_button_array post: pinctrl_tigerlake
    softdep soc_button_array post: pinctrl_intel_platform
  '';

  # Needed for desktop environments to detect display orientation
  hardware.sensor.iio.enable = lib.mkDefault true;

  # Everything is updateable through fwupd
  services.fwupd.enable = true;
}
