{ lib, pkgs, ... }:

{
  imports = [
    ../../../common/cpu/intel/raptor-lake
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  # Cooling management
  services.thermald.enable = lib.mkDefault true;

  # Thunderbolt port (enabled in UEFI)
  services.hardware.bolt.enable = lib.mkDefault true;

  # Fingerprint support
  services.fprintd = {
    enable = lib.mkDefault true;
    tod = {
      enable = lib.mkDefault true;
      driver = pkgs.libfprint-2-tod1-elan;
    };
  };
}
