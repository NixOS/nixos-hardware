{ profile }:

let
  shim = { config, ... }: {
    boot.loader.systemd-boot.enable = !config.boot.loader.generic-extlinux-compatible.enable && !config.boot.loader.raspberryPi.enable;

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/00000000-0000-0000-0000-000000000000";
      fsType = "btrfs";
    };

    nixpkgs.config = {
      allowBroken = true;
      allowUnfree = true;
    };
  };
in (import <nixpkgs/nixos> {
  configuration.imports = [ profile shim ];
}).system
