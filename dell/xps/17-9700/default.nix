{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    # To just use Intel integrated graphics with Intel's open source driver
    ../../../common/gpu/nvidia-disable
  ];

  # TODO: boot loader
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;
  boot.kernelParams = lib.mkDefault [ "acpi_rev_override" ];

  # This will save you money and possibly your life!
  services.thermald.enable = true;
}
