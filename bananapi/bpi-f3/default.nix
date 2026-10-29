{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ ./firmware.nix ];

  boot = {
    consoleLogLevel = lib.mkDefault 7;

    kernelPackages = lib.mkDefault (
      pkgs.linuxPackagesFor (
        pkgs.callPackage ./linux.nix {
          inherit (config.boot) kernelPatches;
        }
      )
    );

    kernelParams = [
      "console=ttyS0,115200n8"
      "earlycon=sbi"
      "clk_ignore_unused"
      "pd_ignore_unused"
      "initcall_blacklist=k1x_pwm_driver_init,spacemit_snd_sspa_init"
      "workqueue.default_affinity_scope=system"
      # Workaround
      "rdinit=/x"
      "root=PARTLABEL=rootfs"
      "rootwait"
      "rootfstype=ext4"
    ];

    initrd.availableKernelModules = [
      "usb_storage"
      "uas"
    ];

    loader = {
      grub.enable = lib.mkDefault false;
      generic-extlinux-compatible.enable = lib.mkDefault true;
    };
  };

  hardware.deviceTree = {
    enable = lib.mkDefault true;
    name = lib.mkDefault "spacemit/k1-x_deb1.dtb";
  };

  systemd.services."serial-getty@ttyS0" = {
    enable = true;
    wantedBy = [ "getty.target" ];
    serviceConfig.Restart = "always";
  };
}
