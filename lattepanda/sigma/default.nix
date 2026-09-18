{ lib, ... }:

{
  imports = [
    ../../common/cpu/intel/raptor-lake
    ../../common/pc
    ../../common/pc/ssd
  ];

  # Intel AX210 WiFi, Intel Bluetooth, and i915 GuC/DMC firmware
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  # Expose package/core temperature sensors
  boot.kernelModules = [ "coretemp" ];
}
