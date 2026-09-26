{ ... }:
{
  nixpkgs.overlays = [
    (import ./overlay.nix)
  ];

  imports = [
    ./modules.nix
  ];

  # Do not set hardware.deviceTree.name — the UKI must omit DeviceTree
  # (meta-qcom KERNEL_DEVICETREE=""; NHLOS MultiDTB FIT supplies lemans-el2).
  hardware.deviceTree.filter = "lemans-*.dtb";
}
