{
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.hostPlatform = "aarch64-linux";

  boot = {
    kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ./bsp/imx8mp-linux.nix { });
    initrd.includeDefaultModules = lib.mkForce false;
  };

  disabledModules = [ "profiles/all-hardware.nix" ];

  hardware.deviceTree.enable = true;
}
