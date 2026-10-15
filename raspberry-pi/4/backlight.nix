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
        If hardware.raspberry-pi."4".backlight.enable was false, remove it without adding firmware configuration.
        If it was true, use rpi-backlight for the firmware-controlled display:

          {
            boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
            hardware.raspberry-pi.configtxt = {
              # Prevent autodetection from loading a competing display overlay.
              settings.pi4.display_auto_detect = false;
              # Remove the default KMS overlay for this firmware-controlled display.
              deviceTreeOverlays.all = [ ];
              deviceTreeOverlays.pi4 = [ { rpi-backlight = { }; } ];
            };
          }

        Remove manually configured KMS overlays for the same display too.
        Do not use this firmware backlight driver for a KMS-controlled panel.

        rpi-backlight controls the backlight through firmware:
        https://github.com/raspberrypi/linux/blob/e165a3e0c5c6729d077c30c6d720c029d688d99d/arch/arm/boot/dts/overlays/rpi-backlight-overlay.dts

        For firmware installation, read "Firmware boot configuration" in raspberry-pi/README.md.
        For display configuration, see:
        https://www.raspberrypi.com/documentation/accessories/display.html
      ''
    )
  ];
}
