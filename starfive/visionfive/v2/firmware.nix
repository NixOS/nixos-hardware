{ config, pkgs, lib, ... }:
let
  cfg = config.hardware.visionfive2;
in
{
  options = {
    hardware.visionfive2 = {
      opensbi.src = lib.mkOption {
        description = "VisionFive2 OpenSBI source";
        type = lib.types.nullOr lib.types.package;
        default = null;
      };
      uboot.src = lib.mkOption {
        description = "VisionFive2 U-boot source";
        type = lib.types.nullOr lib.types.package;
        default = null;
      };
    };
  };

  config = {
    system.build = {
      opensbi = (pkgs.callPackage ./opensbi.nix {}).overrideAttrs (f: p: {
        src = if cfg.opensbi.src != null then cfg.opensbi.src else p.src;
      });

      uboot = (pkgs.callPackage ./uboot.nix { inherit (config.system.build) opensbi; }).overrideAttrs (f: p: {
        src = if cfg.uboot.src != null then cfg.uboot.src else p.src;
      });

      updater-flash = pkgs.writeShellApplication {
        name = "visionfive2-firmware-update-flash";
        runtimeInputs = [ pkgs.mtdutils ];
        text = ''
          flashcp -v ${config.system.build.uboot}/u-boot-spl.bin.normal.out /dev/mtd0
          flashcp -v ${config.system.build.uboot}/u-boot.itb /dev/mtd2
        '';
      };

      updater-sd = pkgs.writeShellApplication {
        name = "visionfive2-firmware-update-sd";
        runtimeInputs = [ ];
        text = ''
          dd if=${config.system.build.uboot}/u-boot-spl.bin.normal.out of=/dev/mmcblk0p1 conv=fsync
          dd if=${config.system.build.uboot}/u-boot.itb of=/dev/mmcblk0p2 conv=fsync
        '';
      };
    };
  };
}
