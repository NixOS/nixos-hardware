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
    # AMD has better battery life with PPD over TLP:
    # https://community.frame.work/t/responded-amd-7040-sleep-states/38101/13
    services.power-profiles-daemon.enable = mkDefault true;
    services.tlp.enable = mkDefault false;
  };
}
