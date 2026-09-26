{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.hardware.bpi-f3;
in

{
  options.hardware.bpi-f3 = {
    opensbi = {
      src = lib.mkOption {
        description = "BPI-F3 OpenSBI source override (defaults to liberodark/spacemit-openspi nixos branch).";
        type = lib.types.nullOr lib.types.package;
        default = null;
      };
      patches = lib.mkOption {
        description = "Additional patches to apply to BPI-F3 OpenSBI.";
        type = lib.types.nullOr (lib.types.listOf lib.types.package);
        default = null;
      };
    };

    uboot = {
      src = lib.mkOption {
        description = "BPI-F3 U-Boot source override (defaults to liberodark/spacemit-uboot-2022.10 nixos branch).";
        type = lib.types.nullOr lib.types.package;
        default = null;
      };
      patches = lib.mkOption {
        description = "Additional patches to apply to BPI-F3 U-Boot.";
        type = lib.types.nullOr (lib.types.listOf lib.types.package);
        default = null;
      };
    };

    fsbl = {
      src = lib.mkOption {
        description = "BPI-F3 FSBL source override (defaults to liberodark/spacemit-uboot-2022.10 vendor base).";
        type = lib.types.nullOr lib.types.package;
        default = null;
      };
      patches = lib.mkOption {
        description = "Additional patches to apply to BPI-F3 FSBL.";
        type = lib.types.nullOr (lib.types.listOf lib.types.package);
        default = null;
      };
    };
  };

  config = {
    system.build = {
      opensbi = (pkgs.callPackage ./opensbi.nix { }).overrideAttrs (
        _final: prev: {
          src = if cfg.opensbi.src != null then cfg.opensbi.src else prev.src;
          patches = if cfg.opensbi.patches != null then cfg.opensbi.patches else (prev.patches or [ ]);
        }
      );

      uboot = (pkgs.callPackage ./uboot.nix { }).overrideAttrs (
        _final: prev: {
          src = if cfg.uboot.src != null then cfg.uboot.src else prev.src;
          patches = if cfg.uboot.patches != null then cfg.uboot.patches else (prev.patches or [ ]);
        }
      );

      fsbl = (pkgs.callPackage ./fsbl.nix { }).overrideAttrs (
        _final: prev: {
          src = if cfg.fsbl.src != null then cfg.fsbl.src else prev.src;
          patches = if cfg.fsbl.patches != null then cfg.fsbl.patches else (prev.patches or [ ]);
        }
      );

      updater-sd = pkgs.writeShellApplication {
        name = "bpi-f3-firmware-update-sd";
        runtimeInputs = [ pkgs.coreutils ];
        text = ''
          dev=''${1:-/dev/mmcblk0}
          dd if=${config.system.build.fsbl}/FSBL.bin of=''${dev}p1 conv=fsync,notrunc
          dd if=${config.system.build.opensbi}/share/opensbi/lp64/generic/firmware/fw_dynamic.itb of=''${dev}p3 conv=fsync,notrunc
          dd if=${config.system.build.uboot}/u-boot.itb of=''${dev}p4 conv=fsync,notrunc
        '';
      };
    };
  };
}
