{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot.kernelPackages = lib.mkDefault (pkgs.callPackage ./kernel.nix { });
  boot.extraModulePackages = [ (config.boot.kernelPackages.callPackage ./lpc.nix { }) ];
}
