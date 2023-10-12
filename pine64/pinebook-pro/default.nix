# This configuration file can be safely imported in your system configuration.
{ pkgs, lib, ... }:

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

    # PCIe/NVMe
    "nvme"
    "pcie_rockchip_host"
    "phy_rockchip_pcie"

    # Misc. modules
    "cw2015_battery"
    "gpio_charger"
    "rtc_rk808"
  ];

  hardware.enableRedistributableFirmware = true;

  # The default powersave makes the wireless connection unusable.
  networking.networkmanager.wifi.powersave = lib.mkDefault false;
}
