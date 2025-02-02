{ lib
, pkgs
, config
, ...
}:
let
  cfg = config.hardware.radxa;
in {
  options.hardware.radxa = {
    enable = lib.mkEnableOption "Radxa system support";
  };

  config = lib.mkIf cfg.enable {
    boot = {
      # Currently enable bcachefs automatically set
      # kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
      kernelPackages = lib.mkOverride 990 pkgs.linuxPackages_latest;
      supportedFilesystems = [ "bcachefs" ];
      loader.systemd-boot.enable = lib.mkDefault true;
    };
  };
}
