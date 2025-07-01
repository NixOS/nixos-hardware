{
  config,
  pkgs,
  lib,
  ...
}:
let
  p = pkgs.writeScriptBin "charge-upto" ''
    echo ''${0:-100} > /sys/class/power_supply/BAT?/charge_control_end_threshold
  '';
  cfg = config.hardware.asus.battery;
in

{
  options.hardware.asus.battery = {
    chargeUpto = lib.mkOption {
      description = "Maximum level of charge for your battery, as a percentage.";
      default = 100;
      type = lib.types.int;
    };
    enableChargeUptoScript = lib.mkOption {
      description = "Whether to add charge-upto to environment.systemPackages. `charge-upto 75` temporarily sets the charge limit to 75%.";
      default = true;
      type = lib.types.bool;
    };
  };
  config = {
    environment.systemPackages = lib.mkIf cfg.enableChargeUptoScript [ p ];
    systemd.services.battery-charge-threshold = {
      wantedBy = [
        "local-fs.target"
        "suspend.target"
      ];
      after = [
        "local-fs.target"
        "suspend.target"
      ];
      description = "Set the battery charge threshold to ${toString cfg.chargeUpto}%";
      startLimitBurst = 5;
      startLimitIntervalSec = 1;
      serviceConfig = {
        Type = "oneshot";
        Restart = "on-failure";
        ExecStart = "${pkgs.runtimeShell} -c 'echo ${toString cfg.chargeUpto} > /sys/class/power_supply/BAT?/charge_control_end_threshold'";
      };
    };
  };
}
