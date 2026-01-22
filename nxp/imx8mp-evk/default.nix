{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (import ./overlay.nix)
  ];

  imports = [
    ./modules.nix
  ];

  boot.loader.grub.extraFiles = {
    "imx8mp-evk.dtb" = "${pkgs.callPackage ./bsp/imx8mp-linux.nix { }}/dtbs/freescale/imx8mp-evk.dtb";
  };

  hardware.deviceTree = {
    filter = "imx8mp-*.dtb";
    name = "imx8mp-evk.dtb";
  };
}
