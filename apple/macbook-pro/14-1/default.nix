{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ../.
    ../../../common/pc/laptop/ssd
  ];

  ##
  # Make the keyboard work in stage1
  # https://www.kernelconfig.io/config_keyboard_applespi
  ##
  boot.initrd.kernelModules = [ "applespi" "spi_pxa2xx_platform" "intel_lpss_pci" "applesmc" ];

  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.0") pkgs.linuxPackages_latest;

  ##
  # Disable d3cold on the NVME controller so the machine can actually
  # wake up.
  # https://github.com/Dunedan/mbp-2016-linux
  ##
  systemd.services.disable-nvme-d3cold = {
    description = "Disables d3cold on the NVME controller";
    before      = [ "suspend.target" ];
    path        = [ pkgs.bash pkgs.coreutils ];

    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = "${./disable-nvme-d3cold.sh}";
    serviceConfig.TimeoutSec = 0;

    wantedBy = [ "multi-user.target" "suspend.target" ];
  };

  ##
  # For some reason /dev/ttyS0 is created, and then removed by udev. We need this
  # for bluetooth, and the only way to get it again is to reload 8502_dw. Luckily,
  # nothing else uses it.
  ##
  systemd.services.btattach-bcm2e7c = lib.mkIf config.hardware.bluetooth.enable {
    before = [ "bluetooth.target" ];

    # Hacky, as it's a different device,  but this always comes after ttyS0
    after = [ "sys-devices-platform-serial8250-tty-ttyS1.device" ];
    path = [ pkgs.bash pkgs.kmod pkgs.bluez ];

    serviceConfig.Type = "simple";
    serviceConfig.ExecStart = "${./btfix.sh}";

    wantedBy = [ "multi-user.target" ];
  };
}
