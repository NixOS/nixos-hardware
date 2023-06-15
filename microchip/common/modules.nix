{ pkgs, lib, ... }: {
  boot = {
    kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ./bsp/linux-icicle-kit.nix { });
    initrd.includeDefaultModules = lib.mkForce false;
  };

}
