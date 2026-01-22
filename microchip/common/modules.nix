{
  pkgs,
  lib,
  config,
  ...
}:
{
  boot = {
    kernelPackages = pkgs.linuxPackagesFor (
      pkgs.callPackage ./bsp/linux-icicle-kit.nix {
        inherit (config.boot) kernelPatches;
      }
    );
    initrd.includeDefaultModules = lib.mkDefault false;
  };
}
