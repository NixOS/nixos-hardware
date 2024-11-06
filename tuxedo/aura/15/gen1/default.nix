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
  hardware =
    if lib.versionAtLeast (lib.versions.majorMinor lib.version) "24.11" then
      {
        tuxedo-drivers.enable = lib.mkDefault true;
      }
    else
      {
        tuxedo-keyboard.enable = lib.mkDefault true;
      };
}
