{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ../. ];
  boot = {
    # kernelParams = [ "console=ttyS2,1500000n8" ];
    kernelParams = [
      "no_console_suspend"
      "console=tty1"
      "pcie_aspm=off" # pcie seems broken on kernel 6.19. Original post https://community.mnt.re/t/error-message-after-apt-update-upgrade/4188/7
    ];
    # kernel modules needed for the virtual console
    initrd.availableKernelModules = [
      "gpio_shared_proxy"
      "panel_edp"
      "phy_rockchip_samsung_hdptx"
      "rockchipdrm"
      "ti_sn65dsi86"
    ];

  };
  boot.loader = {
    grub.enable = false;
    generic-extlinux-compatible.enable = true;
  };
  hardware.alsa.enablePersistence = true;
  system.activationScripts.asound = ''
    if [ ! -e "/var/lib/alsa/asound.state" ]; then
      mkdir -p /var/lib/alsa
      cp ${./initial-asound.state} /var/lib/alsa/asound.state
    fi
  '';
}
