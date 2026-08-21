{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hardware.intel.compute-stick.stck1a.sd-slot-fix;
  sd-slot-fix-overlay-initrd = pkgs.stdenv.mkDerivation {
    name = "sd-slot-fix-overlay-initrd";
    src = ./dsl;

    phases = [
      "unpackPhase"
      "installPhase"
    ];

    nativeBuildInputs = with pkgs; [
      acpica-tools
      cpio
    ];

    installPhase = ''
      mkdir -p kernel/firmware/acpi

      iasl -sa sd-slot-cd-gpio-fix.dsl

      cp sd-slot-cd-gpio-fix.aml kernel/firmware/acpi/
      find kernel | cpio -H newc --create > $out
    '';
  };
in
{
  options.hardware = {
    intel.compute-stick.stck1a.sd-slot-fix = {
      enable = lib.mkEnableOption ''
        fix for the Intel Compute Stick STCK1A SD slot.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    boot.initrd.prepend = [
      (toString sd-slot-fix-overlay-initrd)
    ];
  };
}
