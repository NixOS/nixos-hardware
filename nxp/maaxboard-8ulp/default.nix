{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (import ./overlay.nix)
  ];

  imports = [
    ./modules.nix
  ];

  boot.loader.grub.extraFiles = {
    "maaxboard-8ulp.dtb" = "${
      pkgs.callPackage ./bsp/maaxboard-8ulp-linux.nix { }
    }/dtbs/freescale/maaxboard-8ulp.dtb";
  };

  hardware.deviceTree = {
    filter = "maaxboard-*.dtb";
    name = "maaxboard-8ulp.dtb";
  };
}
