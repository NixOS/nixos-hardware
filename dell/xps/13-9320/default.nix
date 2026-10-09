{ lib, ... }:
{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  services.fprintd.enable = lib.mkDefault true;

  # Make the webcam work.
  hardware.ipu6.enable = lib.mkDefault true;
  hardware.ipu6.platform = lib.mkDefault "ipu6ep";
}
