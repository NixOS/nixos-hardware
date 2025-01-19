{ lib, pkgs, ... }:
let inherit (lib) mkDefault;
in
{
  imports = [
    ../../common/pc/laptop
    ../../common/pc/laptop/ssd
    ../../common/cpu/amd
    ../../common/cpu/amd/pstate.nix
    ../../common/gpu/amd
    ../../common/hidpi.nix
  ];

  boot.kernelParams = [
    # The GPD Pocket 4 uses a tablet LTPS display, that is mounted rotated 90° counter-clockwise
    "fbcon=rotate:1" "video=eDP-1:panel_orientation=right_side_up"
  ];

  fonts.fontconfig = {
    subpixel.rgba = "vbgr"; # Pixel order for rotated screen

    # The display has √(2560² + 1600²) px / 8.8in ≃ 343 dpi
    # Per the documentation, antialiasing, hinting, etc. have no visible effect at such high pixel densities anyhow.
    hinting.enable = mkDefault false;
  };

  # More HiDPI settings
  services.xserver.dpi = 343;
}
