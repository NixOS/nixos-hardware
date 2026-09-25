{ lib, ... }:

{
  imports = [
    (lib.mkRemovedOptionModule
      [
        "hardware"
        "raspberry-pi"
        "4"
        "touch-ft5406"
      ]
      ''
        For the legacy firmware touchscreen, use the rpi-ft5406 overlay:

          {
            boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
            hardware.raspberry-pi.configtxt = {
              settings.pi4.display_auto_detect = false;
              deviceTreeOverlays.all = [ ];
              deviceTreeOverlays.pi4 = [ { rpi-ft5406 = { }; } ];
            };
          }

        The empty all list removes the profile's default KMS overlay.
        Remove any explicitly configured KMS display overlays too.
        This retains the 800x480 firmware touchscreen, not the direct I2C driver.

        For firmware installation, read "Device tree overlays" in
        raspberry-pi/README.md. For display configuration, see:
        https://www.raspberrypi.com/documentation/accessories/display.html
      ''
    )
  ];
}
