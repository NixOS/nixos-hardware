{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot.kernelPackages = pkgs.callPackage ./kernel.nix { };
  boot.extraModulePackages = [ (config.boot.kernelPackages.callPackage ./lpc.nix { }) ];
}
