{ config, lib, ... }:
lib.mkIf (config.hardware.librem5.wifiCard == "redpine") {
  # Disable mainline rsi module
  boot.blacklistedKernelModules = [
    "rsi_91x"
    "rsi_sdio"
  ];

  # Load redpine in Wi-Fi station + BT dual mode
  boot.extraModprobeConfig = ''
    options redpine_91x dev_oper_mode=13 rsi_zone_enabled=1 antenna_diversity=1
  '';

}
