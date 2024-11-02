{ pkgs, lib, ... }:
{

  # Enable IIO for brightness and accelerometer sensors
  hardware.sensor.iio.enable = lib.mkDefault true;

  services.fprintd.enable = lib.mkDefault true;
  
  # Override ACPI DSDT to fix the accelerometer.
  # A driver already exists for a similar sensor.
  # This overrides the IDs to make the existing driver work.
  # From Accelerometer on Linux https://github.com/mudkipme/awesome-minisforum-v3/issues/2#issuecomment-2279282784
  boot.initrd.prepend =
    let
      minisforum-acpi-override = pkgs.stdenv.mkDerivation {
        name = "minisforum-acpi-override";
        CPIO_PATH = "kernel/firmware/acpi";

        src = pkgs.callPackage ./src.nix {};
        patches = [ ./dsdt.patch ];

        nativeBuildInputs = with pkgs; [
          acpica-tools
          cpio
        ];

        installPhase = ''
          mkdir -p $CPIO_PATH
          iasl -tc ./dsdt.dsl
          cp ./dsdt.aml $CPIO_PATH
          find kernel | cpio -H newc --create > acpi_override
          cp acpi_override $out    
        '';
      };
    in
    [ (toString minisforum-acpi-override) ];

  # Fix inverted accelerometer rotation.
  services.udev.extraHwdb = ''
    sensor:modalias:acpi:SMO8B30*:dmi:*svnMicroComputer*:pnV3:*
      ACCEL_MOUNT_MATRIX=-1, 0, 0; 0, -1, 0; 0, 0, -1
  '';

}
