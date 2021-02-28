{ lib, pkgs, ... }:

{
  # This runs only Intel and nvidia does not drain power.

  ##### disable nvidia, very nice battery life.
  hardware.nvidiaOptimus.disable = lib.mkDefault true;
  boot.blacklistedKernelModules = lib.mkDefault [ "nouveau" "nvidia" ];
  services.xserver.videoDrivers = lib.mkDefault [ "intel" ];
}
