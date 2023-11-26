{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault mkEnableOption mkIf mkMerge mkOption types;

  cfg = config.microsoft-surface.ipts;

  iptsConfFile = pkgs.writeTextFile {
    name = "iptsd.conf";
    text = lib.generators.toINI { } cfg.config;
  };

in
{
  options.microsoft-surface.ipts = {
    enable = mkEnableOption "Enable IPTSd for Microsoft Surface";

    config = mkOption {
      type = types.attrs;
      default = { };
      description = ''
        Values to wrote to iptsd.conf, first key is section, second key is property.
        See the example config; https://github.com/linux-surface/iptsd/blob/v1.4.0/etc/iptsd.conf
      '';
      example = ''
        DFT = {
          ButtonMinMag = 1000;
        };
      '';
    };
  };

  config = mkMerge [
    {
      microsoft-surface.ipts.enable = mkDefault false;
    }

    (mkIf cfg.enable {
      systemd.services.iptsd = {
        description = "IPTSD";
        path = with pkgs; [ iptsd ];
        script = "iptsd $(iptsd-find-hidraw)";
        wantedBy = [ "multi-user.target" ];
      };
      environment.etc."iptsd/iptsd.conf".source = "${iptsConfFile}";
    })
  ];
}
