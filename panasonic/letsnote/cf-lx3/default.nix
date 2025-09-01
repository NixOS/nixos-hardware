{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  # Force use of the intel_backlight driver for backlight control.
  # This allows the backlight save/load systemd service to work.
  boot.kernelParams = [ "acpi_backlight=video" ];
}
