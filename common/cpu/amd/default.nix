{ config, lib, ... }:

{
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

  services.hardware.openrgb.motherboard = lib.mkDefault "amd";
}
