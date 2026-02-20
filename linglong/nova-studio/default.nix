{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../../common/cpu/amd
    ../../common/cpu/amd/pstate.nix
    ../../common/cpu/amd/zenpower.nix
    ../../common/gpu/amd
    ../../common/pc/ssd
  ];

  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.14") (
    lib.mkDefault pkgs.linuxPackages_latest
  );
  boot.kernelModules = [ "amdgpu" ];

  hardware.enableRedistributableFirmware = lib.mkDefault true;
  hardware.graphics.enable = lib.mkDefault true;
  hardware.graphics.enable32Bit = lib.mkDefault true;
}
