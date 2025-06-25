{ config, lib, ... }:

{
  # Based on the config from https://www.armbian.com/odroid-hc4/
  hardware.fancontrol = {
    enable = lib.mkDefault true;
    config =
      let
        # According to https://www.armbian.com/odroid-hc4/ the FCFANS line should be removed on kernel 5.15.
        kernelVersion = config.boot.kernelPackages.kernel.version;
        needFcFans = lib.versions.majorMinor kernelVersion != "5.15";
      in
      lib.mkDefault (
        ''
          INTERVAL=10
          DEVPATH=hwmon0=devices/virtual/thermal/thermal_zone0 hwmon2=devices/platform/pwm-fan
          DEVNAME=hwmon0=cpu_thermal hwmon2=pwmfan
          FCTEMPS=hwmon2/pwm1=hwmon0/temp1_input
        ''
        + lib.optionalString needFcFans ''
          FCFANS= hwmon2/pwm1=hwmon2/fan1_input
        ''
        + ''
          MINTEMP=hwmon2/pwm1=50
          MAXTEMP=hwmon2/pwm1=60
          MINSTART=hwmon2/pwm1=20
          MINSTOP=hwmon2/pwm1=28
          MINPWM=hwmon2/pwm1=0
          MAXPWM=hwmon2/pwm1=255
        ''
      );
  };

  # Linux 5.15 sometimes crash under heavy network usage
  systemd.watchdog.runtimeTime = lib.mkDefault "1min";

  hardware.deviceTree.filter = "meson-sm1-odroid-hc4.dtb";
}
