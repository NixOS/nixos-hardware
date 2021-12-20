{ lib, ... }:
{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  # Essential Firmware
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  # Cooling Management
  services.thermald.enable = lib.mkDefault true;

  # Touchpad
  services.xserver = {
    libinput.touchpad.tapping = true;
    libinput.touchpad.tappingDragLock = true;
  };
}
