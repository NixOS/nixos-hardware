{ lib, ... }:

{
  services.xserver.videoDrivers = lib.mkDefault [ "nvidia" ];
}
