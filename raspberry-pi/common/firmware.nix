# Firmware-partition install for Raspberry Pi.
#
# Stages the files the Pi needs before Linux starts onto the firmware partition
# (default /boot/firmware): GPU boot code (bootcode.bin, start*.elf, fixup*.dat),
# vendor device trees and overlays, the rendered config.txt, and optionally
# U-Boot. Not a new boot method: boards still use
# boot.loader.generic-extlinux-compatible (U-Boot reads extlinux.conf); this just
# provides the files that path needs, either from an image builder (populateCmd)
# or on a running system (the opt-in activation script).
#
# DTB/overlay copy adapted from nvmd/nixos-raspberrypi (MIT).

{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.hardware.raspberry-pi.firmware;

  # install-rpi-firmware <target-dir>
  # Idempotent: copies via temp file + rename, and prunes stale DTBs/overlays.
  installScript = pkgs.writeShellApplication {
    name = "install-rpi-firmware";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      target="''${1:-${cfg.path}}"

      firmwareBoot=${cfg.package}/share/raspberrypi/boot
      ${lib.optionalString cfg.useGenerationDeviceTree ''
        # Prefer the booted generation's device trees over the vendor ones.
        dtbSrc=$(readlink -f /run/current-system/dtbs 2>/dev/null || true)
        [ -d "$dtbSrc" ] || dtbSrc=$firmwareBoot
      ''}
      ${lib.optionalString (!cfg.useGenerationDeviceTree) ''
        dtbSrc=$firmwareBoot
      ''}

      mkdir -p "$target" "$target/overlays"

      copyForced() {
        # copy src dst
        cp "$1" "$2.tmp"
        mv "$2.tmp" "$2"
      }

      declare -A kept

      echo "rpi-firmware: copying device trees from $dtbSrc"
      for dtb in "$dtbSrc"/*.dtb "$dtbSrc"/broadcom/*.dtb; do
        [ -e "$dtb" ] || continue
        dst="$target/$(basename "$dtb")"
        copyForced "$dtb" "$dst"
        kept[$dst]=1
      done

      if [ -d "$dtbSrc/overlays" ]; then
        for ovr in "$dtbSrc"/overlays/*; do
          [ -e "$ovr" ] || continue
          dst="$target/overlays/$(basename "$ovr")"
          copyForced "$ovr" "$dst"
          kept[$dst]=1
        done
      fi

      # Prune stale device trees / overlays.
      for fn in "$target"/*.dtb "$target"/overlays/*; do
        [ -e "$fn" ] || continue
        if [ "''${kept[$fn]:-}" != 1 ]; then
          rm -vf -- "$fn"
        fi
      done

      echo "rpi-firmware: copying GPU boot code"
      for src in "$firmwareBoot"/bootcode.bin "$firmwareBoot"/start*.elf "$firmwareBoot"/fixup*.dat; do
        [ -e "$src" ] || continue
        copyForced "$src" "$target/$(basename "$src")"
      done

      ${lib.optionalString (cfg.ubootPackage != null) ''
        echo "rpi-firmware: copying U-Boot"
        copyForced ${cfg.ubootPackage}/u-boot.bin "$target/u-boot.bin"
      ''}

      echo "rpi-firmware: copying config.txt"
      copyForced ${config.hardware.raspberry-pi.configtxt.file} "$target/config.txt"

      echo "rpi-firmware: done ($target)"
    '';
  };
in
{
  options.hardware.raspberry-pi.firmware = {
    enable = lib.mkEnableOption ''
      installation of the Raspberry Pi firmware partition on a running system.

      An activation script repopulates {option}`hardware.raspberry-pi.firmware.path`
      on every system switch. Leave off if your image builder already handles it'';

    path = lib.mkOption {
      type = lib.types.str;
      default = "/boot/firmware";
      description = ''
        Mount point of the Raspberry Pi firmware (FAT) partition.
      '';
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.raspberrypifw;
      defaultText = lib.literalExpression "pkgs.raspberrypifw";
      description = ''
        Package providing the Raspberry Pi GPU boot code, vendor device trees,
        and overlays under `share/raspberrypi/boot`.
      '';
    };

    ubootPackage = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = null;
      example = lib.literalExpression "pkgs.ubootRaspberryPiAarch64";
      description = ''
        Optional U-Boot package. When set, its `u-boot.bin` is copied to the
        firmware partition. Point `config.txt`'s `kernel` at `u-boot.bin` to
        chainload it (firmware loads U-Boot, which then reads `extlinux.conf`).

        For 64-bit boards (Pi 3/4/5) use `pkgs.ubootRaspberryPiAarch64`.
      '';
    };

    useGenerationDeviceTree = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Copy device trees from the booted NixOS generation
        (`/run/current-system/dtbs`) instead of the vendor firmware package.
        Only meaningful for the runtime activation script.
      '';
    };

    installScript = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      internal = true;
      default = installScript;
      description = ''
        Script that populates the firmware partition. Takes the target
        directory as its first argument (defaults to
        {option}`hardware.raspberry-pi.firmware.path`).
      '';
    };

    populateCmd = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      default = lib.getExe installScript;
      defaultText = lib.literalExpression "<firmware install script>";
      description = ''
        Command that populates a firmware partition directory given as its
        first argument. Intended for use in image builders, e.g.
        `sdImage.populateFirmwareCommands = "''${config.hardware.raspberry-pi.firmware.populateCmd} ./firmware";`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    system.activationScripts.raspberry-pi-firmware = lib.stringAfter [ "specialfs" ] ''
      if mountpoint -q ${lib.escapeShellArg cfg.path}; then
        ${lib.getExe installScript} ${lib.escapeShellArg cfg.path}
      else
        echo "rpi-firmware: ${cfg.path} is not a mounted partition, skipping firmware install" >&2
      fi
    '';
  };
}
