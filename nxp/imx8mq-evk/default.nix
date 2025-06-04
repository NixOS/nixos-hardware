{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (import ./overlay.nix)
  ];

  imports = [
    ./modules.nix
  ];

  boot.loader.grub.extraFiles = {
    "imx8mq-evk.dtb" = "${pkgs.callPackage ./bsp/imx8mq-linux.nix { }}/dtbs/freescale/imx8mq-evk.dtb";
  };

  hardware.deviceTree = {
    filter = "imx8mq-*.dtb";
    name = "imx8mq-evk.dtb";
  };
}
