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
        If hardware.raspberry-pi."4".dwc2.enable was false, remove the old DWC2 configuration.
        If it was true, enable DWC2 through the shared module:

          {
            hardware.raspberry-pi.dwc2.enable = true;
          }

        If you set hardware.raspberry-pi."4".dwc2.dr_mode, copy it to hardware.raspberry-pi.dwc2.dr_mode.
        The shared module keeps the firmware device tree and removes the CM4 XHCI default.
        Remove any other matching explicit otg_mode configuration.
        For controller selection, see:
        https://www.raspberrypi.com/documentation/computers/config_txt.html#otg_mode

        For firmware installation and USB configuration, read "DWC2 USB controller"
        in raspberry-pi/README.md.
      ''
    )
  ];
}
