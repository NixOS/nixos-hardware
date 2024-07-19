{ lib, ... }:

{
  imports = [ ../24.05-compat.nix ];
  services.xserver.videoDrivers = lib.mkDefault [ "nvidia" ];
  # TODO: this will be a default after https://github.com/NixOS/nixpkgs/pull/326369
  hardware.nvidia.modesetting.enable = lib.mkDefault true;
}
