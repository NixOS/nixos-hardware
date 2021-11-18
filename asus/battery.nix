{ config, pkgs, lib, ... }:
let
  p = pkgs.writeScriptBin "charge-upto" ''
    echo ''${0:-100} > /sys/class/power_supply/BAT0/charge_control_end_threshold
  '';
  cfg = config.hardware.asus;
in

{
  options.hardware.asus.chargeUpto = lib.mkOption {
    description = "Maximum level of charge for your battery, as a percentage.";
    default = 100;
    type = lib.types.int;
  };
  config = {
    environment.systemPackages = [ p ];
    systemd.tmpfiles.rules = [
      "w /sys/class/power_supply/BAT0/charge_control_end_threshold - - - - ${toString cfg.chargeUpto}"
    ];
  };
}
