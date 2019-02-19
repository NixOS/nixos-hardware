{ config, lib, pkgs, ... }:

{
  imports = [
    ../.
    ../../../common/cpu/amd
  ];

  hardware.cpu.intel.enable = false;
  # I'm not sure whether acpi_call works on this laptop
  boot.acpi_call.enable = false;

  boot.extraModprobeConfig = lib.mkDefault ''
    options snd_hda_intel enable=0,1
  '';

  services.xserver.videoDrivers = [ "ati" ];
}
