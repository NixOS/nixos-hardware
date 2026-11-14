{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel/lunar-lake
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  # The touchpad uses I²C, so PS/2 is unnecessary
  boot.blacklistedKernelModules = [ "psmouse" ];

  hardware = {
    # Includes the Wi-Fi, Bluetooth, audio (SOF), GPU and NPU firmware
    enableRedistributableFirmware = lib.mkDefault true;

    # Needed for desktop environments to adjust the brightness automatically
    sensor.iio.enable = lib.mkDefault true;
  };

  services = {
    # Recommended in NixOS/nixos-hardware#127
    thermald.enable = lib.mkDefault true;

    # Goodix fingerprint reader, enroll with `fprintd-enroll`
    fprintd.enable = lib.mkDefault true;
  };
}
