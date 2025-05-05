{
  imports = [
    ../../../common/cpu/intel
    # might need nvidia module but we don't know the PCI ids:
    # https://github.com/NixOS/nixos-hardware/pull/274#discussion_r650483740
    #../../../common/gpu/nvidia/prime.nix
    ../../../common/pc/ssd
  ];

  # Need to set Thunderbolt to "BIOS Assist Mode"
  # https://forums.lenovo.com/t5/Other-Linux-Discussions/T480-CPU-temperature-and-fan-speed-under-linux/m-p/4114832
  boot.kernelParams = [ "acpi_backlight=native" ];

  # Emulate mouse wheel on trackpoint
  # hardware.trackpoint.emulateWheel = true;

  services.fprintd.enable = true;
}
