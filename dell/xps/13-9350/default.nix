{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel/lunar-lake
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  # The touchpad uses I²C, so PS/2 is unnecessary
  boot.blacklistedKernelModules = [ "psmouse" ];

  # Enable fingerprint sensor located on the power button.
  # Works out of the box with fprintd and no additional packages/drivers.
  # Configure for the current user via `fprintd-enroll`.
  services.fprintd.enable = lib.mkDefault true;

  # Recommended in NixOS/nixos-hardware#127
  services.thermald.enable = lib.mkDefault true;
}
