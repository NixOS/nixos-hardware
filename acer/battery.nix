{ lib, config, ... }:
let
  cfg = config.hardware.acer.battery;
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

    boot.extraModprobeConfig = lib.mkIf cfg.enableHealthMode "options acer-wmi-battery enable_health_mode=1";
  };
}
