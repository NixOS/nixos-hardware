{
  imports = [
    ../../../common/cpu/intel
    ../../../common/gpu/nvidia.nix
    ../../../common/pc/laptop/acpi_call.nix
    ../../../common/pc/laptop/ssd
  ];

  # Need to set Thunderbolt to "BIOS Assist Mode"
  # https://forums.lenovo.com/t5/Other-Linux-Discussions/T480-CPU-temperature-and-fan-speed-under-linux/m-p/4114832
  boot.kernelParams = [ "acpi_backlight=native" ];

  # Emulate mouse wheel on trackpoint
  # hardware.trackpoint.emulateWheel = true;

  services.fprintd.enable = true;
}
