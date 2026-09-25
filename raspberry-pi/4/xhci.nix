{ lib, ... }:

{
  imports = [
    (lib.mkRemovedOptionModule
      [
        "hardware"
        "raspberry-pi"
        "4"
        "xhci"
      ]
      ''
        Select the built-in XHCI USB 2.0 host controller through the firmware:

          {
            boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
            hardware.raspberry-pi.configtxt.settings.pi4.otg_mode = 1;
          }

        The profile already sets otg_mode=1 for CM4.
        This controller is an alternative to DWC2, not the Pi 4B PCIe USB 3.0 controller.
        For DWC2 or USB gadget mode, remove all matching otg_mode settings.
        On CM4, this requires hardware.raspberry-pi.configtxt.settings.cm4.otg_mode = null.

        For firmware installation, read "Device tree overlays" in
        raspberry-pi/README.md.
      ''
    )
  ];
}
