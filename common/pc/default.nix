{ config, lib, ... }:

{
  boot.blacklistedKernelModules = lib.optionals (!config.hardware.enableRedistributableFirmware) [
    "ath3k"
  ];

  services.xserver.libinput.enable = lib.mkDefault true;
}
