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
        If hardware.raspberry-pi."4".tv-hat.enable was false, remove the old TV HAT configuration.
        If it was true, use the rpi-tv firmware overlay:

          {
            boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
            hardware.raspberry-pi.configtxt.deviceTreeOverlays."board-type=0x11" = [
              { rpi-tv = { }; }
            ];
          }

        The stock rpi-tv overlay enables SPI0, disables spidev0, and assigns the tuner to CE0:
        https://github.com/raspberrypi/linux/blob/e165a3e0c5c6729d077c30c6d720c029d688d99d/arch/arm/boot/dts/overlays/rpi-tv-overlay.dts

        Do not add spi0-0cs. It removes the SPI0 chip-select pins:
        https://github.com/raspberrypi/firmware/blob/1.20260521/boot/overlays/README#L4871-L4876

        For firmware installation and migration guidance, read "Device tree overlays"
        and "Migrating Pi 4 options" in raspberry-pi/README.md.
      ''
    )
  ];
}
