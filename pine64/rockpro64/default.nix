{ lib, ... }:
{
  imports = [
    ./console.nix
  ];
  boot.initrd.kernelModules = [
    # PCIe/NVMe
    "nvme"
    "pcie_rockchip_host"
    "phy_rockchip_pcie"
    # Network
    "dwmac_rk"
    # HDMI
    "rockchipdrm"
  ];
  # control the fan on the rockpro64 (like the one in the NAS case)
  hardware.fancontrol = {
    enable = lib.mkDefault true;
    config = lib.mkDefault ''
      INTERVAL=3
      DEVPATH=hwmon0=devices/virtual/thermal/thermal_zone0 hwmon1=devices/virtual/thermal/thermal_zone1 hwmon3=devices/platform/pwm-fan
      DEVNAME=hwmon0=cpu_thermal hwmon1=gpu_thermal hwmon3=pwmfan
      # There can only be one sensor mapped to one pwm:
      # https://github.com/lm-sensors/lm-sensors/issues/228
      # Therefore you'll have to decide if you want to check CPU or GPU
      # temps. If you want to use GPU instead, replace hwmon0 with
      # hwmon1 below.
      FCTEMPS=hwmon3/pwm1=hwmon0/temp1_input
      MINTEMP=hwmon3/pwm1=40
      MAXTEMP=hwmon3/pwm1=80
      MINSTART=hwmon3/pwm1=35
      MINSTOP=hwmon3/pwm1=30
      MINPWM=hwmon3/pwm1=0
      MAXPWM=hwmon3/pwm1=255
    '';
  };
}
