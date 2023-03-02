{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault mkEnableOption mkIf mkMerge versionAtLeast;

  cfg = config.microsoft-surface.ipts;

  version-includes-systemd-config = versionAtLeast pkgs.iptsd.version "1.0";

in {
  options.microsoft-surface.ipts = {
    enable = mkEnableOption "Enable IPTSd for Microsoft Surface";
  };

  config = mkMerge [
    {
      microsoft-surface.ipts.enable = mkDefault false;
    }

    (mkIf (cfg.enable && !version-includes-systemd-config) {
      systemd.services.iptsd = {
        description = "IPTSD";
        path = with pkgs; [ iptsd ];
        script = "iptsd";
        wantedBy = [ "multi-user.target" ];
      };
    })

    (mkIf (cfg.enable && version-includes-systemd-config) {
      # TODO:
      # I'm not convinced I need to add pkgs.iptsd to systemd.packages and services.udev.packages;
      # just adding it to environment.systemPackages might be good enough?
      # Looking at be below code, it alread puts the systemd and udev rules into /etc/ :
      # - https://github.com/NixOS/nixpkgs/blob/ae8bdd2de4c23b239b5a771501641d2ef5e027d0/pkgs/applications/misc/iptsd/default.nix#L46-L52

      # TODO:
      # "system.packages" only seems to check for ${package}/lib/systemd/systemd-${type} which means
      # it won't find the iptsd ones, anyway:
      # - https://github.com/NixOS/nixpkgs/blob/10e51cdc0456f1d5c8a00f026c384f0e81126538/nixos/modules/system/boot/systemd.nix#L467-L473
      systemd.packages = [
        pkgs.iptsd
      ];

      # TODO:
      # udev.packages does add files from ${package}/etc/udev/rules.d/ but maybe just adding to
      # environment.systemPackages is good enough?
      # - https://github.com/NixOS/nixpkgs/blob/10e51cdc0456f1d5c8a00f026c384f0e81126538/nixos/modules/services/hardware/udev.nix#L69-L75
      services.udev.packages = [
        pkgs.iptsd
      ];
    })
  ];
}
