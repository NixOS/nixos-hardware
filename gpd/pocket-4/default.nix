{ lib, pkgs, ... }:
let inherit (lib) mkIf mkDefault;
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

  # Add firmware blobs for GPU, wifi, bluetooth.
  # Non-required amdgpu/isp_4_1_0.bin still fails with no impact on usage.
  # Kernel fix coming in https://github.com/torvalds/linux/commit/ea5d49349894a7a74ce8dba242e3a487d24b6c0e
  hardware.firmware = [(import ./firmware.nix { inherit pkgs; })];

  boot = {
    # As of kernel version 6.6.72, amdgpu throws a fatal error during init, resulting in a barely-working display
    kernelPackages = mkIf (lib.versionOlder pkgs.linux.version "6.12") pkgs.linuxPackages_latest;

    kernelParams = [
      # The GPD Pocket 4 uses a tablet LTPS display, that is mounted rotated 90° counter-clockwise
      "fbcon=rotate:1" "video=eDP-1:panel_orientation=right_side_up"
    ];
  };

  fonts.fontconfig = {
    subpixel.rgba = "vbgr"; # Pixel order for rotated screen

    # The display has √(2560² + 1600²) px / 8.8in ≃ 343 dpi
    # Per the documentation, antialiasing, hinting, etc. have no visible effect at such high pixel densities anyhow.
    hinting.enable = mkDefault false;
  };

  # More HiDPI settings
  services.xserver.dpi = 343;
}
