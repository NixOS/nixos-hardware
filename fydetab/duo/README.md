# Fydetab Duo

The Fydetab Duo is an open source and hackable tablet by FydeOS.

## Features

- Display: **works**
  - X11: **untested**
  - Wayland: **working** (COSMIC), niri and sway **untested**
- GPU driver: **working** (Panthor, Mesa Panfrost)
- WiFi: **working**
- Cellular: **untested**
- SD card: **untested**
- Sound: **untested**
- Fingerprint: **untested**

## Flashing

Flashing requires `rkdeveloptool` and using it to write the new bootloader and eMMC image. To flash, press and hold the mask rom button on the board. Ensure a USB C cable is already plugged into the host computer. Run `nix build .#nixosConfigurations.<hostname>.config.hardware.rockchip.platformFirmware` and then use `rkdeveloptool ul result/rk3588_loader_v*.bin`. The NixOS image can then be downloaded using `rkdeveloptool wl 0`, it is recommended to use the disko image configuration which is provided.
