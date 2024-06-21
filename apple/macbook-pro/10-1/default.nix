{ lib, ... }:

{
  imports = [
    ../.
    ../../../common/pc/laptop/ssd
  ];

  # TODO: reverse compat
  hardware.graphics.enable32Bit = lib.mkDefault true;

  services.xserver = {
    # TODO: we should not enable unfree drivers
    # when there is an alternative (i.e. nouveau)
    videoDrivers = [ "nvidia" ];
  };
}
