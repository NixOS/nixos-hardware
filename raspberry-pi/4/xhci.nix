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
        If hardware.raspberry-pi."4".xhci.enable was false, remove the old XHCI configuration.
        If it was true, select the built-in XHCI USB 2.0 host controller through the firmware:

          {
            boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
            hardware.raspberry-pi.configtxt.settings.pi4.otg_mode = 1;
          }

        The shared defaults in raspberry-pi/common/config-txt-defaults.nix
        set hardware.raspberry-pi.configtxt.settings.cm4.otg_mode = true.
        For DWC2 or USB gadget mode, remove any explicit otg_mode configuration from matching filter sections.
        On CM4, also set hardware.raspberry-pi.configtxt.settings.cm4.otg_mode = null.

        For controller selection, read "DWC2" in raspberry-pi/README.md.
        For boot migration and firmware installation, read "Firmware boot configuration" in the same file.
      ''
    )
  ];
}
