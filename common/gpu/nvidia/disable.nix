{ lib, pkgs, ... }:

{
  # This runs only intel/amdgpu igpus and nvidia dgpus do not drain power.

  ##### disable nvidia, very nice battery life.
  hardware.nvidiaOptimus.disable = lib.mkDefault true;
  boot.blacklistedKernelModules = lib.mkDefault [ "nouveau" "nvidia" ];
}
