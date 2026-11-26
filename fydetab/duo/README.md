# Fydetab Duo

The Fydetab Duo is an open source and hackable tablet by FydeOS.

## Features

- Display: **works**
  - X11: **untested**
  - Wayland: **working** (COSMIC), niri and sway **untested**
  - USB-C DisplayPort: **working**, but buggy with some docks and chargers. It needs more testing.
- GPU driver: **working** (Panthor, Mesa Panfrost)
- Touchscreen: **working**
- Stylus: **working**, side buttons **not working**
- WiFi: **working**
- Cellular: **detected** by ModemManager (Quectel EM05). Data is untested. Some units have the EM05-CE, which only has LTE bands 1, 3, 5, 8 and the China TDD bands.
- SD card: **untested**
- Sound: **working** (speakers), headphones **untested**
- Bluetooth: **working**
- Fingerprint: **untested**

## Flashing

Flashing requires `rkdeveloptool` and using it to write the new bootloader and eMMC image. To flash, press and hold the mask rom button on the board. Ensure a USB C cable is already plugged into the host computer. Run `nix build .#nixosConfigurations.<hostname>.config.hardware.rockchip.platformFirmware` and then use `rkdeveloptool ul result/rk3588_loader_v*.bin`. The NixOS image can then be downloaded using `rkdeveloptool wl 0`, it is recommended to use the disko image configuration which is provided.

## U-Boot resources

U-Boot shows its charging and loader bitmaps from `system.build.ubootResource`. It only finds this image in a GPT partition named `resource`, so the disk layout must have one. Write the image to that partition, for example from the disko `extraPostVM` hook.
