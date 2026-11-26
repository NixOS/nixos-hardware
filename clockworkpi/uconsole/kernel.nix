# uConsole Kernel Configuration
#
# Applies kernel patches for uConsole-specific hardware:
# - CWU50 display panel driver
# - AXP228 power management
# - OCP8178 backlight controller
# - Device tree overlays
#
# Patches extracted from https://github.com/cuu/ClockworkPi-linux
# (ClockworkPi's fork of the Raspberry Pi kernel with uConsole drivers)

{ lib, ... }:

let
  patches = [
    ./patches/0001-configs.patch
    ./patches/0002-panel.patch
    ./patches/0003-power.patch
    ./patches/0004-backlight.patch
    ./patches/0005-overlays.patch
    ./patches/0006-bcm2835-staging.patch
    ./patches/0007-simple-switch.patch
  ];
in
{
  boot.initrd.kernelModules = [
    "ocp8178_bl"
    "panel_cwu50"
    "vc4"
  ];

  boot.kernelPatches = map (patch: {
    name = builtins.baseNameOf patch;
    patch = patch;
  }) patches;
}
