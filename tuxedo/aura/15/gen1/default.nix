{ lib, ... }:
{
  imports = [
    ../../../../common/cpu/amd
    ../../../../common/pc/laptop
    ../../../../common/pc/ssd
  ];

  # Cooling management
  services.thermald.enable = lib.mkDefault true;

  # keyboard backlight lives in /sys/class/leds/rgb:kbd_backlight
  hardware.tuxedo-drivers.enable = lib.mkDefault true;
}
