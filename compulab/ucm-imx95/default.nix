{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (import ./overlay.nix)
  ];

  imports = [
    ./modules.nix
  ];

  boot.loader.grub.extraFiles = {
    "ucm-imx95.dtb" = "${pkgs.callPackage ./bsp/ucm-imx95-linux.nix { }}/dtbs/compulab/ucm-imx95.dtb";
  };

  hardware.deviceTree = {
    filter = "ucm-imx95.dtb";
    name = "ucm-imx95.dtb";
  };
}
