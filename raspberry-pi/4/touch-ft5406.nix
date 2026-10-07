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
        If hardware.raspberry-pi."4".touch-ft5406.enable was false, remove the old touchscreen configuration.
        If it was true, use rpi-ft5406 for the legacy firmware touchscreen:

          {
            boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
            hardware.raspberry-pi.configtxt = {
              settings.pi4.display_auto_detect = false;
              deviceTreeOverlays.all = [ ];
              deviceTreeOverlays.pi4 = [ { rpi-ft5406 = { }; } ];
            };
          }

        The [ ] value for hardware.raspberry-pi.configtxt.deviceTreeOverlays.all
        removes the shared default vc4-kms-v3d overlay.
        Remove any explicitly configured KMS display overlays too.
        This retains the removed module's 800x480 firmware touchscreen.
        It does not select the direct I2C driver.

        For firmware installation and migration guidance, read "Device tree overlays"
        and "Migrating Pi 4 options" in raspberry-pi/README.md.
        For display configuration, see:
        https://www.raspberrypi.com/documentation/accessories/display.html
      ''
    )
  ];
}
