{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (import ./overlay.nix)
  ];

  imports = [
    ../common/modules.nix
  ];

  boot.loader.grub.extraFiles = {
    "imx8qm-mek.dtb" = "${
      pkgs.callPackage ../common/bsp/linux-imx8.nix { }
    }/dtbs/freescale/imx8qm-mek.dtb";
  };

  hardware.deviceTree = {
    filter = "imx8qm-*.dtb";
    name = "imx8qm-mek.dtb";
  };
}
