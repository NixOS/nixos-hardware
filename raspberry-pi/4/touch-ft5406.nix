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
        If hardware.raspberry-pi."4".touch-ft5406.enable was false, remove it without adding firmware configuration.
        If it was true, use rpi-ft5406 for the firmware-controlled touchscreen:

          {
            boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
            hardware.raspberry-pi.configtxt = {
              # Prevent autodetection from loading a competing display overlay.
              settings.pi4.display_auto_detect = false;
              # Remove the default KMS overlay for this firmware-controlled display.
              deviceTreeOverlays.all = [ ];
              deviceTreeOverlays.pi4 = [ { rpi-ft5406 = { }; } ];
            };
          }

        Remove manually configured KMS overlays for the same display to avoid competing display drivers.
        This enables the 800x480 firmware touchscreen.
        It does not select the direct I2C driver.

        For firmware installation, read "Firmware boot configuration" in raspberry-pi/README.md.
        For display configuration, see:
        https://www.raspberrypi.com/documentation/accessories/display.html
      ''
    )
  ];
}
