{
  nixpkgs.overlays = [
    (import ./overlay.nix)
  ];

  imports = [
    ../common/modules.nix
  ];

  hardware.deviceTree = {
    name = "microchip/mpfs-icicle-kit.dtb";
  };
}
