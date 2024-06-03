{
  config,
  pkgs,
  lib,
  ...
}:
let
  # This interface works for most Asus, Lenovo Thinkpad, LG, System76, and Toshiba laptops
  # A list of supported laptop models/vendors supporting the following interface can be found
  # at https://linrunner.de/tlp/settings/bc-vendors.html
  # If your laptop isn't supported, considering installing and using the tlp package's setcharge command instead
  interfaces = "/sys/class/power_supply/BAT?/charge_control_end_threshold";
  charge-upto-script = pkgs.writeScriptBin "charge-upto" ''
    echo ''${1:-100} >${interfaces}
  '';
  cfg = config.hardware.battery;
in

{
  options.hardware.battery = {
    chargeUpto = lib.mkOption {
      description = "Maximum level of charge for your battery, as a percentage. Applies threshold to all installed batteries";
      default = 100;
      type = lib.types.int;
    };
    enableChargeUptoScript = lib.mkOption {
      description = "Whether to add charge-upto script to environment.systemPackages. `charge-upto 75` temporarily sets the charge limit to 75%.";
      default = true;
      type = lib.types.bool;
    };
  };
  imports = (
    map
      (
        option:
        lib.mkRemovedOptionModule [
          "hardware"
          "asus"
          "battery"
          option
        ] "The hardware.asus.battery.* options were removed in favor of `hardware.battery.*`."
      )
      [
        "chargeUpto"
        "enableChargeUptoScript"
      ]
  );
  config = {
    environment.systemPackages = lib.mkIf cfg.enableChargeUptoScript [ charge-upto-script ];
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
        ExecStart = "${pkgs.runtimeShell} -c 'echo ${toString cfg.chargeUpto} > ${interfaces}'";
      };
    };
  };
}
