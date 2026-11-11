# ClockworkPi uConsole (CM4 variant)
#
# A portable handheld device based on Raspberry Pi CM4 with:
# - CWU50 5" DSI display (720x1280)
# - AXP228 power management IC
# - OCP8178 backlight controller
# - Custom audio routing
# - Optional 4G modem expansion
#
# https://www.clockworkpi.com/uconsole

{ lib, ... }:

{
  imports = [
    ../../raspberry-pi/4
    ./kernel.nix
    ./modem-4g.nix
  ];

  # Filter device tree to CM4 variants (override rpi4 default)
  hardware.deviceTree.filter = lib.mkForce "bcm2711-rpi-cm4*.dtb";
}
