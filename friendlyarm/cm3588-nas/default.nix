{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ../../rockchip
  ];

  config = {
    hardware = {
      rockchip = {
        rk3588.enable = true;
        platformFirmware = lib.mkDefault pkgs.ubootCM3588NAS;
      };

      deviceTree.name = lib.mkDefault "rockchip/rk3588-friendlyelec-cm3588-nas.dtb";
    };

    boot = {
      initrd.kernelModules = [
        "nvme"

        # PCI
        "pcie_rockchip_host"
        "phy_rockchip_naneng_combphy"
        "phy_rockchip_pcie"

        # USB
        "tcpm"
        "typec"
        "thunderbolt"
        "fusb302"

        # Networking
        "r8169"

        # Graphics
        "analogix_dp"
        "cec"
        "drm_display_helper"
        "drm_dma_helper"
        "drm_dp_aux_bus"
        "drm_exec"
        "drm_gpuvm"
        "dw_hdmi_qp"
        "dw_hdmi"
        "dw_mipi_dsi"
        "gpu_sched"
        "panthor"
        "phy_rockchip_samsung_hdptx"
        "phy_rockchip_usbdp"
        "rockchipdrm"

        # Misc
        "rk805_pwrkey"
        "rockchip_dfi"
        "rockchip_rga"
        "rockchip_saradc"
        "rockchip_thermal"
        "rtc_hym8563"
      ];

      kernelParams = [
        "earlycon"
        "rootwait"
        "splash"
        "console=tty1"
        "consoleblank=0"
      ];
    };
  };
}
