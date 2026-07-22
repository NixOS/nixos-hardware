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
      "earlycon=sbi"
      "keep_bootcon"
      "systemd.journald.forward_to_console=1"
      "systemd.log_target=kmsg"
      "systemd.log_level=info"
      "clk_ignore_unused"
      "pd_ignore_unused"
      "root=PARTLABEL=nixos-rootfs"
      "rootwait"
      "rootfstype=ext4"
    ];

    initrd = {
      availableKernelModules = [
        "usb_storage"
        "uas"
        "nvme"
        "nvme_core"
      ];
      kernelModules = [
        "erofs"
        "loop"
      ];
    };

    loader = {
      systemd-boot.enable = lib.mkDefault true;
      systemd-boot.consoleMode = lib.mkDefault "auto";
      timeout = lib.mkDefault 3;
      efi.canTouchEfiVariables = lib.mkDefault false;
      efi.efiSysMountPoint = lib.mkDefault "/boot";
      generic-extlinux-compatible.enable = lib.mkDefault false;
    };

    zfs.forceImportRoot = lib.mkDefault false;
  };

  hardware.deviceTree = {
    enable = lib.mkDefault true;
    name = lib.mkDefault "spacemit/k3-pico-itx.dtb";
  };

  boot.initrd.systemd.enable = lib.mkDefault true;
  system.nixos-init.enable = lib.mkDefault true;
  system.etc.overlay.enable = lib.mkDefault true;
  services.userborn.enable = lib.mkDefault true;

  systemd.services."serial-getty@ttyS0" = {
    enable = true;
    wantedBy = [ "getty.target" ];
    serviceConfig.Restart = "always";
  };
}
