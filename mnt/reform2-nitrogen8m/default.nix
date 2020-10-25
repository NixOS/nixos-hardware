{ config, lib, pkgs, ... }:

{
  boot = {
    initrd = {
      availableKernelModules = [ "nvme" "usbhid" ];
      kernelModules = [ "nwl-dsi" "imx-dcss" ];
    };
    extraModprobeConfig = "options imx-dcss dcss_use_hdmi=0";
    kernelPackages = lib.mkDefault pkgs.linuxPackages_reformNitrogen8m_latest;
    kernelParams = [ "console=ttymxc0,115200" "console=tty1" "pci=nomsi" ];
    loader = {
      generic-extlinux-compatible.enable = lib.mkDefault true;
      grub.enable = lib.mkDefault false;
      timeout = lib.mkDefault 1;
      # Cannot interact with U-Boot directly
    };
  };

  environment.etc."systemd/system.conf".text = "DefaultTimeoutStopSec=15s";

  environment.systemPackages = with pkgs; [ brightnessctl usbutils ];

  hardware.deviceTree.name = lib.mkDefault "freescale/imx8mq-mnt-reform2.dtb";

  hardware.pulseaudio.daemon.config.default-sample-rate = lib.mkDefault "48000";

  nixpkgs = {
    system = "aarch64-linux";
    overlays = [
      (final: prev:
        with final; {

          linux_reformNitrogen8m_latest = callPackage ./kernel.nix {
            linux = linux_5_7;
            kernelPatches = [ ];
          };

          linuxPackages_reformNitrogen8m_latest =
            linuxPackagesFor final.linux_reformNitrogen8m_latest;

          ubootReformImx8mq = callPackage ./uboot { };

        })
    ];
  };

  system.activationScripts.asound = ''
    if [ ! -e "/var/lib/alsa/asound.state" ]; then
      mkdir -p /var/lib/alsa
      cp ${./initial-asound.state} /var/lib/alsa/asound.state
    fi
  '';
}
