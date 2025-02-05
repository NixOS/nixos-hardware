{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
  ];

  # Important Firmware
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  
  boot = {
    # Kernel Panic on suspend fix, taken from ArchLinux wiki.
    kernelParams = [ "acpi_enforce_resources=lax" "i915.enable_dc=0" ];
    # Audio Mute LED
    extraModprobeConfig = ''
       options snd-hda-intel model=mute-led-gpio
    '';
  };
}
