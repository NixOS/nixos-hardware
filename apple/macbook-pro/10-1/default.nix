{ lib, pkgs, ... }:

{
  imports = [
    ../.
    ../../../common/pc/laptop/ssd
  ];

  # TODO: reverse compat
  hardware.opengl.driSupport32Bit = true;

  services.xserver = {
    # TODO: we should not enable unfree drivers
    # when there is an alternative (i.e. nouveau)
    videoDrivers = [ "nvidia" ];
  };
}
