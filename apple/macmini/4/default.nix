{
  lib,
  ...
}:
let
  inherit (lib) mkDefault;
in
{
  imports = [
    ../.
  ];

  services.xserver.videoDrivers = mkDefault [ "nvidiaLegacy340" ];

  hardware.opengl = {
    enable = mkDefault true;
    driSupport = mkDefault true;
    driSupport32Bit = mkDefault true;
  };

  hardware.nvidia = {
    modesetting.enable = mkDefault true;
    powerManagement.enable = mkDefault false;
    powerManagement.finegrained = mkDefault false;
    open = mkDefault false;
    nvidiaSettings = mkDefault true;
  };
}
