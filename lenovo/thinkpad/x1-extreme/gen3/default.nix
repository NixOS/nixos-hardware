{ lib, ... }:

{
  imports = [
    ../.
  ];

  # New ThinkPads have a different TrackPoint manufacturer/name.
  hardware.trackpoint.device = "TPPS/2 Elan TrackPoint";

  # Fix clickpad (clicking by depressing the touchpad).
  boot.kernelParams = [ "psmouse.synaptics_intertouch=0" ];

  # Set the right DPI. xdpyinfo says the screen is 677x423 mm but
  # it actually is 344×215 mm.
  services.xserver.monitorSection = lib.mkDefault ''
    DisplaySize 344 215
  '';
}
