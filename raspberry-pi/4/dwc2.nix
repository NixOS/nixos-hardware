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

        For CM4 and firmware-partition setup, see "DWC2 USB controller" in
        raspberry-pi/README.md.
      ''
    )
  ];
}
