{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    # To just use Intel integrated graphics with Intel's open source driver
    # ../../../common/gpu/nvidia/disable.nix
  ];

  # TODO: boot loader
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  # This will save you money and possibly your life!
  services.thermald.enable = true;
}
