{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.hardware.k3-pico-itx;
in

{
  options.hardware.k3-pico-itx = {
    opensbi = {
      src = lib.mkOption {
        description = "K3 Pico-ITX OpenSBI source override.";
        type = lib.types.nullOr lib.types.package;
        default = null;
      };
      patches = lib.mkOption {
        description = "Additional patches to apply to K3 Pico-ITX OpenSBI.";
        type = lib.types.nullOr (lib.types.listOf lib.types.package);
        default = null;
      };
    };

    uboot = {
      src = lib.mkOption {
        description = "K3 Pico-ITX U-Boot source override.";
        type = lib.types.nullOr lib.types.package;
        default = null;
      };
      patches = lib.mkOption {
        description = "Additional patches to apply to K3 Pico-ITX U-Boot.";
        type = lib.types.nullOr (lib.types.listOf lib.types.package);
        default = null;
      };
    };

    fsbl = {
      src = lib.mkOption {
        description = "K3 Pico-ITX FSBL source override.";
        type = lib.types.nullOr lib.types.package;
        default = null;
      };
      patches = lib.mkOption {
        description = "Additional patches to apply to K3 Pico-ITX FSBL.";
        type = lib.types.nullOr (lib.types.listOf lib.types.package);
        default = null;
      };
    };

    edk2 = {
      src = lib.mkOption {
        description = "K3 Pico-ITX EDK2 (UEFI) source override.";
        type = lib.types.nullOr lib.types.package;
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

      edk2 = (pkgs.callPackage ./edk2.nix { }).overrideAttrs (
        _final: prev: {
          src = if cfg.edk2.src != null then cfg.edk2.src else prev.src;
        }
      );

      updater-sd = pkgs.writeShellApplication {
        name = "k3-pico-itx-firmware-update-sd";
        runtimeInputs = [ pkgs.coreutils ];
        text = ''
          dev=''${1:-/dev/mmcblk0}
          dd if=${config.system.build.fsbl}/FSBL.bin of=''${dev}p3 conv=fsync,notrunc
          dd if=${config.system.build.opensbi}/share/opensbi/lp64/generic/firmware/fw_dynamic.itb of=''${dev}p5 conv=fsync,notrunc
          dd if=${config.system.build.edk2}/edk2.itb of=''${dev}p6 conv=fsync,notrunc
        '';
      };
    };
  };
}
