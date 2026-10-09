# Firmware

This laptop requires MediaTek firmware to work, sadly the Wi-Fi + Bluetooth chip (MT7925) is
soldered on board and can't be changed.  The firmware is unfree, and is enabled via
`hardware.enableAllFirmware`, so you need to allow installation of unfree packages or enable unfree
firmware manually:

```nix
nixpkgs.config.allowUnfreePredicate =
  pkg:
  builtins.elem (lib.getName pkg) [
    "broadcom-bt-firmware"
    "b43-firmware"
    "xone-dongle-firmware"
    "facetimehd-calibration"
    "facetimehd-firmware"
  ];
```
