{ config, lib, pkgs, ... }:

{
  imports = [ ../../common/pc/laptop/ssd ];

  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_reformNitrogen8m_latest;

    kernelParams = [ "console=ttymxc0,115200" "console=tty1" "pci=nomsi" ];

    extraModprobeConfig = "options imx-dcss dcss_use_hdmi=0";

    initrd = {
      kernelModules = [ "nwl-dsi" "imx-dcss" ];
      availableKernelModules = # hack to remove ATA modules
        lib.mkForce ([
          "cryptd"
          "dm_crypt"
          "dm_mod"
          "input_leds"
          "mmc_block"
          "nvme"
          "usbhid"
          "xhci_hcd"
        ] ++ config.boot.initrd.luks.cryptoModules);
    };

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

          linux_5_7 = callPackage ./kernel/linux-5.7.nix {
            kernelPatches = [
              kernelPatches.bridge_stp_helper
              kernelPatches.request_key_helper
              kernelPatches.export_kernel_fpu_functions."5.3"
            ];
          };

          linux_reformNitrogen8m_latest =
            callPackage ./kernel { kernelPatches = [ ]; };

          linuxPackages_reformNitrogen8m_latest =
            linuxPackagesFor linux_reformNitrogen8m_latest;

          ubootReformImx8mq = callPackage ./uboot { };

        })
    ];
  };

  programs.sway.extraPackages = # unbloat
    lib.mkDefault (with pkgs; [ swaylock swayidle xwayland ]);

  system.activationScripts.asound = let
    initialAsoundState = pkgs.fetchurl {
      url =
        "https://source.mnt.re/reform/reform-system-image/-/raw/84bec717ad7366b1d385f3200da192efb0f5bccb/reform2-imx8mq/template-etc/asound.state";
      sha256 = "11wfy8fad5mhr6bga36k7lri85wq74rfzwj9bb9j5rp5cll4jnmb";
    };
  in ''
    if [ ! -e "/var/lib/alsa/asound.state" ]; then
      mkdir -p /var/lib/alsa
      cp ${initialAsoundState} /var/lib/alsa/asound.state
    fi
  '';

}
