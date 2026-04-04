{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel/kaby-lake
    ../../../common/pc/ssd
    ../.
  ];

  services.xserver.videoDrivers = [ "modesetting" ];

  services = {
    fwupd.enable = lib.mkDefault true;
    thermald.enable = lib.mkDefault true;
  };
}
