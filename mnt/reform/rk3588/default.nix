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
    ];
    # kernel modules needed for the virtual console
    initrd.availableKernelModules = [
      "panel-edp"
      "phy-rockchip-samsung-hdptx"
      "rockchipdrm"
      "ti-sn65dsi86"
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
