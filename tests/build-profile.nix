{ profile }:

let
  shim = { config, lib, pkgs, ... }: {
    boot.loader.systemd-boot.enable = !config.boot.loader.generic-extlinux-compatible.enable && !config.boot.loader.raspberryPi.enable;
    # we forcefully disable grub here just for testing purposes, even though some profiles might still use grub in the end.
    boot.loader.grub.enable = false;

    # so we can have assertions that require a certain minimum kernel version,
    # We use a priority of 1200 here, which is higher than the default of 1000
    boot.kernelPackages = lib.mkOverride 1200 pkgs.linuxPackages_latest;

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/00000000-0000-0000-0000-000000000000";
      fsType = "btrfs";
    };

    nixpkgs.config = {
      allowBroken = true;
      allowUnfree = true;
      nvidia.acceptLicense = true;
    };
  };
in (import <nixpkgs/nixos> {
  configuration.imports = [ profile shim ];
}).system
