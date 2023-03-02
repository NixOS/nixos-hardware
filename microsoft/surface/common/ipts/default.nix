{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault mkEnableOption mkIf mkMerge versionOlder;

  cfg = config.microsoft-surface.ipts;

in {
  options.microsoft-surface.ipts = {
    enable = mkEnableOption "Enable IPTSd for Microsoft Surface";
  };

  config = mkMerge [
    {
      microsoft-surface.ipts.enable = mkDefault false;
    }

    (mkIf cfg.enable {
      assertions = [
        {
          assertion = versionOlder iptsd.version "1.0.1";
          message = "Nixpkgs provides a udev and systemd config after v0.5.1";
        }
      ];
      systemd.services.iptsd = {
        description = "IPTSD";
        path = with pkgs; [ iptsd ];
        script = "iptsd";
        wantedBy = [ "multi-user.target" ];
      };
    })
  ];
}
