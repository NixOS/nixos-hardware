{
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.hostPlatform.system = "aarch64-linux";

  boot = {
    kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ./bsp/ucm-imx95-linux.nix { });
    initrd.includeDefaultModules = lib.mkForce false;
  };

  disabledModules = [ "profiles/all-hardware.nix" ];

  hardware.deviceTree.enable = true;
}
