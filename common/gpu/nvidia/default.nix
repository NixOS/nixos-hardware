{ lib, ... }:

{
  imports = [ ../24.05-compat.nix ];
  services.xserver.videoDrivers = lib.mkDefault [ "nvidia" ];
}
