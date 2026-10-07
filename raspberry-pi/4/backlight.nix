{ lib, ... }:

{
  imports = [
    (lib.mkRemovedOptionModule
      [
        "hardware"
        "raspberry-pi"
        "4"
        "backlight"
      ]
      ''
        If hardware.raspberry-pi."4".backlight.enable was false, remove the old backlight configuration.
        If it was true, use rpi-backlight for the legacy firmware-controlled display:

          {
            boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
            hardware.raspberry-pi.configtxt = {
              settings.pi4.display_auto_detect = false;
              deviceTreeOverlays.all = [ ];
              deviceTreeOverlays.pi4 = [ { rpi-backlight = { }; } ];
            };
          }

        The [ ] value for hardware.raspberry-pi.configtxt.deviceTreeOverlays.all
        removes the shared default vc4-kms-v3d overlay.
        Remove any explicitly configured KMS display overlays too.
        Do not use this firmware backlight driver for a KMS-controlled panel.

        The stock firmware package still supplies rpi-backlight.
        Its overlay uses the same firmware backlight driver as the removed module:
        https://github.com/raspberrypi/linux/blob/e165a3e0c5c6729d077c30c6d720c029d688d99d/arch/arm/boot/dts/overlays/rpi-backlight-overlay.dts

        For firmware installation and migration guidance, read "Device tree overlays"
        and "Migrating Pi 4 options" in raspberry-pi/README.md.
        For display configuration, see:
        https://www.raspberrypi.com/documentation/accessories/display.html
      ''
    )
  ];
}
