{ lib, config, ... }:
with lib;
let
  cfg = config.hardware.gpd.duo.powerManagement;
in
{
  options.hardware.gpd.duo.powerManagement = {
    enable = mkEnableOption "Enable power-profiles-daemon and disable TLP for the GPD Duo" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    services.power-profiles-daemon.enable = mkDefault true;
    services.tlp.enable = mkForce false;
  };
}
