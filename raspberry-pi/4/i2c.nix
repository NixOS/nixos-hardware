{ lib, ... }:

{
  imports = [
    (lib.mkRemovedOptionModule
      [
        "hardware"
        "raspberry-pi"
        "4"
        "i2c0"
      ]
      ''
        Enable the VideoCore I2C bus through the base device-tree parameters:

          {
            boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
            hardware.i2c.enable = true;
            hardware.raspberry-pi.configtxt.settings.pi4.dtparam = [ "i2c0=on" ];
          }

        If frequency was not null, append "i2c0_baudrate=400000" to the dtparam list.
        Replace 400000 with the previous value in Hz.
        For the default frequency, omit the baudrate parameter.
        Keep hardware.i2c.enable for i2c-dev and the i2c group permissions.

        Use the base parameter, not the i2c0 overlay, which changes the bus
        pin assignment and disables its multiplexer.
        For firmware installation, read "Device tree overlays" in
        raspberry-pi/README.md.
      ''
    )
    (lib.mkRemovedOptionModule
      [
        "hardware"
        "raspberry-pi"
        "4"
        "i2c1"
      ]
      ''
        Enable the ARM I2C bus through the base device-tree parameters:

          {
            boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
            hardware.i2c.enable = true;
            hardware.raspberry-pi.configtxt.settings.pi4.dtparam = [ "i2c1=on" ];
          }

        If frequency was not null, append "i2c1_baudrate=400000" to the dtparam list.
        Replace 400000 with the previous value in Hz.
        For the default frequency, omit the baudrate parameter.
        Keep hardware.i2c.enable for i2c-dev and the i2c group permissions.

        For firmware installation, read "Device tree overlays" in
        raspberry-pi/README.md.
      ''
    )
  ];
}
