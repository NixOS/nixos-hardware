{ lib, ... }:

{
  imports = [
    (lib.mkRemovedOptionModule
      [
        "hardware"
        "raspberry-pi"
        "4"
        "tc358743"
      ]
      ''
        Use the tc358743 firmware overlay:

          {
            boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
            hardware.raspberry-pi.configtxt.deviceTreeOverlays.pi4 = [
              { tc358743 = { }; }
            ];
          }

        The stock defaults use two CSI lanes and disable the Media Controller API.
        If lanes was 4, set tc358743."4lane" = true in the overlay entry.
        Four lanes require a suitably wired Compute Module CAM1 connector.
        If media-controller was enabled, set tc358743.media-controller = true.

        For firmware installation, read "Device tree overlays" in
        raspberry-pi/README.md.
      ''
    )
  ];
}
