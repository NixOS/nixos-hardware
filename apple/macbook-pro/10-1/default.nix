{ lib, ... }:

{
  imports = [
    ../.
    ../../../common/pc/laptop/ssd
    ../../../common/gpu/24.05-compat.nix
    ../../../common/gpu/nvidia/kepler
  ];

  # TODO: reverse compat
  hardware.graphics.enable32Bit = lib.mkDefault true;

  services.xserver = {
    # TODO: we should not enable unfree drivers
    # when there is an alternative (i.e. nouveau)
    videoDrivers = [ "nvidia" ];
  };
}
