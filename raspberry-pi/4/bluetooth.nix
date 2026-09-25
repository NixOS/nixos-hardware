{ lib, ... }:

{
  imports = [
    (lib.mkRemovedOptionModule
      [
        "hardware"
        "raspberry-pi"
        "4"
        "bluetooth"
      ]
      ''
        Use the firmware device tree instead of the build-time UART pin workaround:

          {
            boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
            hardware.raspberry-pi.configtxt.settings.pi4.dtparam = [ "krnbt=on" ];
            hardware.bluetooth.enable = true;
          }

        The firmware configures the Bluetooth UART pins. krnbt enables kernel
        discovery of the Bluetooth controller.
        If you use kernel discovery, remove any custom btattach or hciattach service.

        For firmware installation, read "Device tree overlays" in
        raspberry-pi/README.md.
      ''
    )
  ];
}
