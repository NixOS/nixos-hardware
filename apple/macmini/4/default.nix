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

  hardware = {
    graphics = {
      enable = mkDefault true;
      enable32Bit = mkDefault true;
    };

    nvidia = {
      modesetting.enable = mkDefault true;
      powerManagement.enable = mkDefault false;
      powerManagement.finegrained = mkDefault false;
      open = mkDefault false;
      nvidiaSettings = mkDefault true;
    };
  };
}
