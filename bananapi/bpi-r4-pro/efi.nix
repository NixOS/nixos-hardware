{
  config,
  lib,
  pkgs,
  ...
}:

# Boot NixOS through U-Boot's EFI loader and stock systemd-boot.
#
# WHY THIS REPLACES THE FIT
# -------------------------
# The board used to boot a raw FIT out of the `production` GPT partition.  A
# FIT carries its kernel command line *inside the image*, and our bootargs
# contained
#
#   init=/nix/var/nix/profiles/system/init
#
# i.e. an absolute pointer to whatever generation existed when the FIT was
# built.  U-Boot's image_setup_libfdt() overwrites /chosen/bootargs from its env,
# so the FIT had to be reflashed on every generation change -- that is what
# ./fit.nix's `fit-sync` unit did.  Whenever it lagged, the board booted an old
# kernel against new `kernel-modules`, came up with no network, and could only be
# fixed over the serial console.  Flashing a trial generation made it worse:
# the FIT pinned every reboot to the trial.
#
# An ESP removes the entire problem.  systemd-boot reads
#
#   <esp>/loader/entries/nixos-generation-<N>.conf
#
# and *that* file carries the `init=` for its own generation.  `nixos-rebuild
# boot` writes a new entry; the previous ones stay selectable; nothing needs to
# be reflashed and no bootloader is owned by a stale image.
#
# There are no EFI variables on this board (U-Boot exposes none that persist
# across a reflash, and the ESP is a fixed partition), so systemd-boot is
# installed with --no-variables and the ESP is populated at IMAGE BUILD time
# rather than by running `bootctl install` on the device.
let
  cfg = config.hardware.bananapi.bpi-r4-pro;

  # Where the ESP lives inside the SD image.  It is a normal GPT partition; the
  # board's BL2/U-Boot find it by PARTLABEL, not by fixed sector.
  espLabel = "ESP";
in
{
  options.hardware.bananapi.bpi-r4-pro.efiBoot = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = ''
      Boot via U-Boot's EFI loader + systemd-boot on an ESP partition, instead
      of the vendor U-Boot loading a raw FIT.

      Requires {option}`hardware.bananapi.bpi-r4-pro.buildFirmware`, whose
      U-Boot is the one built with `CONFIG_EFI_LOADER`.
    '';
  };

  config = lib.mkIf (cfg.enable && cfg.efiBoot) {
    assertions = [
      {
        assertion = cfg.buildFirmware;
        message = ''
          hardware.bananapi.bpi-r4-pro.efiBoot needs buildFirmware: the EFI
          loader lives in our own U-Boot build.  The vendor firmware has no
          `bootefi`, so an ESP would be unbootable.
        '';
      }
    ];

    # --- systemd-boot ---------------------------------------------------
    boot.loader.systemd-boot.enable = lib.mkForce true;
    # No EFI variables on this board: U-Boot's EFI variable store is not
    # persistent here, so bootctl must not try to write BootOrder/Boot####.
    boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
    # The kernel + initrd live on the ESP so U-Boot's EFI loader can find them
    # without a Linux-visible root filesystem.  The ESP is a dedicated VFAT
    # partition created by ./sd-image.nix and mounted here; systemd-boot treats
    # this as efiSysMountPoint.
    boot.loader.efi.efiSysMountPoint = lib.mkDefault "/boot";

    # Keep a healthy number of generations so a bad upgrade is always rollable
    # from the systemd-boot menu on the serial console.
    boot.loader.systemd-boot.configurationLimit = lib.mkDefault 20;

    # The FIT used to disable every NixOS loader; that was correct then and is
    # exactly wrong now.  grub/extlinux stay off: systemd-boot is the loader.
    boot.loader.grub.enable = lib.mkForce false;
    boot.loader.generic-extlinux-compatible.enable = lib.mkForce false;

    # --- the ESP must exist and be labelled -----------------------------
    fileSystems."/boot" = {
      device = "/dev/disk/by-partlabel/${espLabel}";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    # systemd-boot's own package is used by the installer path; on this board we
    # pre-populate instead (see ./sd-image.nix), so make sure the `bootctl`
    # semantics are right for a variable-less install.
    boot.loader.systemd-boot.graceful = lib.mkDefault true;
  };
}
