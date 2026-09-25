{ lib, ... }:

{
  imports = [
    (lib.mkRemovedOptionModule
      [
        "hardware"
        "raspberry-pi"
        "4"
        "dwc2"
      ]
      ''
        Use the stock dwc2 firmware overlay instead:

          {
            boot.loader.generic-extlinux-compatible.useGenerationDeviceTree =
              false;

            hardware.raspberry-pi.configtxt.deviceTreeOverlays.pi4 = [
              { dwc2 = { }; }
            ];
          }

        If you set dr_mode on the old option, add it to the overlay. For
        example:

          { dwc2.dr_mode = "host"; }

        On CM4, also remove the profile's default XHCI selection:

          hardware.raspberry-pi.configtxt.settings.cm4.otg_mode = null;

        For firmware installation, read "Device tree overlays" in
        raspberry-pi/README.md.
      ''
    )
  ];
}
