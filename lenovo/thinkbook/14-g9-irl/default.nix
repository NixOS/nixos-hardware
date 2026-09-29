{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel/raptor-lake
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  # Cooling management
  services.thermald.enable = lib.mkDefault true;

  # Match-on-Chip fingerprint reader in the power button.
  # Verify the sensor on your unit and enroll after enabling:
  #   lsusb | grep -iE 'fingerprint|synaptics|goodix|validity'
  #   fprintd-enroll $USER
  # If the reader needs a proprietary TOD driver (e.g. Goodix), add:
  #   services.fprintd.tod = { enable = true; driver = pkgs.libfprint-2-tod1-goodix; };
  # (pattern: dell/g3/3500) - needs `pkgs` in the function arguments above.
  services.fprintd.enable = lib.mkDefault true;
}
