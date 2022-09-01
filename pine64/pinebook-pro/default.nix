# This configuration file can be safely imported in your system configuration.
{ config, pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (import ./overlay.nix)
  ];

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  # This list of modules is not entirely minified, but represents
  # a set of modules that is required for the display to work in stage-1.
  # Further minification can be done, but requires trial-and-error mainly.
  boot.initrd.kernelModules = [
    # Rockchip modules
    "rockchip_rga"
    "rockchip_saradc"
    "rockchip_thermal"
    "rockchipdrm"

    # GPU/Display modules
    "analogix_dp"
    "cec"
    "drm"
    "drm_kms_helper"
    "dw_hdmi"
    "dw_mipi_dsi"
    "gpu_sched"
    "panel_edp"
    "panel_simple"
    "panfrost"
    "pwm_bl"

    # USB / Type-C related modules
    "fusb302"
    "tcpm"
    "typec"

    # Misc. modules
    "cw2015_battery"
    "gpio_charger"
    "rtc_rk808"
  ];

  services.udev.extraHwdb = lib.mkMerge [
    # https://github.com/elementary/os/blob/05a5a931806d4ed8bc90396e9e91b5ac6155d4d4/build-pinebookpro.sh#L253-L257
    # Disable the "keyboard mouse" in libinput. This is reported by the keyboard firmware
    # and is probably a placeholder for a TrackPoint style mouse that doesn't exist
    ''
      evdev:input:b0003v258Ap001Ee0110-e0,1,2,4,k110,111,112,r0,1,am4,lsfw
        ID_INPUT=0
        ID_INPUT_MOUSE=0
    ''
  ];

  # https://github.com/elementary/os/blob/05a5a931806d4ed8bc90396e9e91b5ac6155d4d4/build-pinebookpro.sh#L253-L257
  # Mark the keyboard as internal, so that "disable when typing" works for the touchpad
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Pinebook Pro Keyboard]
    MatchUdevType=keyboard
    MatchBus=usb
    MatchVendor=0x258A
    MatchProduct=0x001E
    AttrKeyboardIntegration=internal
  '';

  hardware.enableRedistributableFirmware = true;
  hardware.firmware = [
    (pkgs.callPackage ./firmware/ap6256-firmware { })
  ];

  systemd.tmpfiles.rules = [
    # Tweak the minimum frequencies of the GPU and CPU governors to get a bit more performance
    # https://github.com/elementary/os/blob/05a5a931806d4ed8bc90396e9e91b5ac6155d4d4/build-pinebookpro.sh#L288-L294
    "w- /sys/devices/system/cpu/cpufreq/policy0/scaling_min_freq - - - - 1200000"
    "w- /sys/devices/system/cpu/cpufreq/policy4/scaling_min_freq - - - - 1008000"
    "w- /sys/class/devfreq/ff9a0000.gpu/min_freq - - - - 600000000"
  ];

  # The default powersave makes the wireless connection unusable.
  networking.networkmanager.wifi.powersave = lib.mkDefault false;
}
