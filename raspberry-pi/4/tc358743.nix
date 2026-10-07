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
        If hardware.raspberry-pi."4".tc358743.enable was false, remove the old TC358743 configuration.
        If it was true, use the tc358743 firmware overlay:

          {
            boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
            hardware.raspberry-pi.configtxt.deviceTreeOverlays.pi4 = [
              { tc358743 = { }; }
            ];
          }

        The stock defaults use two CSI lanes and disable the Media Controller API.
        If hardware.raspberry-pi."4".tc358743.lanes was 4, set tc358743."4lane" = true in the overlay entry.
        Four lanes require a suitably wired Compute Module CAM1 connector.
        If hardware.raspberry-pi."4".tc358743.media-controller was true, set tc358743.media-controller = true.

        For firmware installation and migration guidance, read "Device tree overlays"
        and "Migrating Pi 4 options" in raspberry-pi/README.md.
      ''
    )
  ];
}
