{ lib, ... }:
{
  imports = [
    ../../../common/cpu/intel/kaby-lake
    ../../../common/pc/laptop
    ./xps-common.nix
  ];

  # Includes the Wi-Fi and Bluetooth firmware
  hardware.enableRedistributableFirmware = lib.mkDefault true;
}
