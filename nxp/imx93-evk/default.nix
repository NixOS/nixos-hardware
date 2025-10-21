{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (import ./overlay.nix)
  ];

  imports = [
    ./modules.nix
  ];

  boot.loader.grub.extraFiles = {
    "imx93-11x11-evk.dtb" = "${
      pkgs.callPackage ./bsp/imx93-linux.nix { }
    }/dtbs/freescale/imx93-11x11-evk.dtb";
  };

  hardware.deviceTree = {
    filter = "imx93-*.dtb";
    name = "imx93-11x11-evk.dtb";
  };
}
