{ lib, pkgs, ... }:
let
  inherit (lib) mkIf mkDefault;
in
{
  imports = [
    ../../common/pc/laptop
    ../../common/pc/ssd
    ../../common/cpu/amd
    ../../common/cpu/amd/pstate.nix
    ../../common/gpu/amd
    ../../common/hidpi.nix
  ];

  boot = {
    # As of kernel version 6.6.72, amdgpu throws a fatal error during init, resulting in a barely-working display
    kernelPackages = mkIf (lib.versionOlder pkgs.linux.version "6.12") pkgs.linuxPackages_latest;

    kernelParams = [
      # The GPD Pocket 4 uses a tablet LTPS display, that is mounted rotated 90° counter-clockwise
      "fbcon=rotate:1"
      "video=eDP-1:panel_orientation=right_side_up"
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

  # disable fingerprint reader, it currently has no linux drivers anyways and also blocks suspend (at least on my system)
  services.udev.extraRules = /* udev */ ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="2808", ATTR{idProduct}=="0752", ATTR{authorized}="0"
  '';

  # classify device as convertible (see hostnamectl)
  environment.etc.machine-info = {
    text = ''
      CHASSIS=convertible
    '';
    mode = "0440";
  };
}
