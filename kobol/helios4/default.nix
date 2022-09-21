{ pkgs, ... }:

{
  imports = [
    ./modules/fancontrol.nix
  ];

  nixpkgs.overlays = [
    (import ./overlay.nix)
  ];

  nixpkgs.hostPlatform = "armv7l-linux";

  boot.initrd.availableKernelModules = [ "ahci_mvebu" ];

  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_5_15_helios4;
}
