{ pkgs, lib, ... }:
{
  nixpkgs.hostPlatform = "aarch64-linux";

  boot = {
    kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ./bsp/linux-imx8.nix { });
    kernelParams = [ "console=ttyLP0,115200n8" ];
    loader.grub.enable = lib.mkDefault true;
    initrd.includeDefaultModules = lib.mkForce false;
  };

  disabledModules = [ "profiles/all-hardware.nix" ];

  hardware.deviceTree.enable = true;
}
