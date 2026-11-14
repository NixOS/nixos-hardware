{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.hardware.acer.battery;
  acerBatteryToggleHealthMode = pkgs.writeShellApplication {
    name = "acer_battery_toggle_health_mode";
    text = ''
      toggle_path="/sys/module/acer_wmi_battery/drivers/wmi:acer-wmi-battery/health_mode"
      enabled=$(cat "$toggle_path")
      if [ $enabled -eq 0 ]; then
        echo 1 | sudo tee "$toggle_path"
        echo "Enabled battery health mode"
      else
        echo 0 | sudo tee "$toggle_path"
        echo "Disabled battery health mode"
      fi
    '';
  };
in
{
  options.hardware.acer.battery = with lib; {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable the Acer battery control kernel module.";
    };
    enableHealthMode = mkEnableOption "to limit battery charge to 80% and save battery health.";
  };

  config = lib.mkIf cfg.enable {
    boot.extraModulePackages = [ config.boot.kernelPackages.acer-wmi-battery ];
    boot.kernelModules = [ "acer-wmi-battery" ];
    environment.systemPackages = [ acerBatteryToggleHealthMode ];

    boot.extraModprobeConfig = lib.mkIf cfg.enableHealthMode "options acer-wmi-battery enable_health_mode=1";
  };
}
