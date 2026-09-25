{ lib, ... }:

{
  imports = [
    (lib.mkRemovedOptionModule
      [
        "hardware"
        "raspberry-pi"
        "4"
        "tv-hat"
      ]
      ''
        Use the rpi-tv firmware overlay:

          {
            boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
            hardware.raspberry-pi.configtxt.deviceTreeOverlays."board-type=0x11" = [
              { rpi-tv = { }; }
            ];
          }

        The vendor device tree already supplies the SPI0 pins and chip selects.
        rpi-tv enables SPI0 and replaces spidev0 with the tuner on CE0.
        Do not add spi0-0cs, which removes the chip selects.

        For firmware installation, read "Device tree overlays" in
        raspberry-pi/README.md.
      ''
    )
  ];
}
