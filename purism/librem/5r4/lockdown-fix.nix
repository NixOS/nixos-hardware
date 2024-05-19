{ config, pkgs, lib, ... }:
lib.mkIf config.hardware.librem5.lockdownFix {
  # We blacklist the drivers so they don't load during early boot when the sensors are disconnected,
  boot.blacklistedKernelModules = [
    "st_lsm6dsx_spi"
    "st_lsm6dsx_i2c"
    "st_lsm6dsx"
  ];

  # and load them when the phone is fully booted;
  systemd.services.librem5-lockdown-support = {
    description = "Set up drivers for the orientation and proximity sensors on Librem 5";
    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = "${config.hardware.librem5.package}/bin/lockdown-support.sh";
    wantedBy = [ "default.target" ];
    path = [ pkgs.kmod ];
  };

  # udev rules from librem5-base handle going into "lockdown mode" and back.
  assertions = [{
    assertion = with config.hardware.librem5;
      lockdownFix -> installUdevPackages;
    message =
      "'hardware.librem5.lockdownFix' requires 'hardware.librem5.installUdevPackages', but it is not enabled.";
  }];
}
