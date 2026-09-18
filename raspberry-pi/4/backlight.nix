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
        For the legacy firmware-controlled display, use the rpi-backlight overlay:

          {
            boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
            hardware.raspberry-pi.configtxt = {
              settings.pi4.display_auto_detect = false;
              deviceTreeOverlays.all = [ ];
              deviceTreeOverlays.pi4 = [ { rpi-backlight = { }; } ];
            };
          }

        The empty all list removes the profile's default KMS overlay.
        Remove any explicitly configured KMS display overlays too.
        Do not use this firmware backlight driver for a KMS-controlled panel.

        For firmware installation, read "Device tree overlays" in
        raspberry-pi/README.md. For display configuration, see:
        https://www.raspberrypi.com/documentation/accessories/display.html
      ''
    )
  ];
}
