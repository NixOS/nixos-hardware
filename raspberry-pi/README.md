# Raspberry Pi

NixOS profiles and modules for Raspberry Pi boards.

## What's here

- `common/` has the shared bits: the `linux-rpi` kernel build (vendor defconfig, matching firmware), the `config.txt` generation module, a pinned wireless firmware, and the firmware-partition install module.
- `2/`, `3/`, `4/`, `5/` are the board profiles. Each one picks the right kernel and kernel params. Pi 4 and 5 also set DT filters and the initrd modules they need.
- The extra files under `4/` are opt-in toggles for Pi 4 hardware: audio, dwc2, GPIO, I2C, LEDs, the PoE HATs, touchscreens, and so on.

## Using a board profile

```nix
{
  imports = [
    <nixos-hardware/raspberry-pi/4>
  ];
}
```

These profiles assume the `generic-extlinux-compatible` bootloader (the NixOS module that writes an `extlinux.conf` for U-Boot to read), which is what aarch64 NixOS SD images use by default. There is no `boot.loader.raspberry-pi` module here. U-Boot and the GPU boot code still have to land on the firmware partition somehow: either your image builder does it, or you use the firmware install module below.

## Firmware install

`hardware.raspberry-pi.firmware` stages the files the Pi firmware needs before Linux starts onto the firmware partition (default `/boot/firmware`): GPU boot code (`bootcode.bin`, `start*.elf`, `fixup*.dat`), vendor device trees and overlays, the rendered `config.txt`, and optionally U-Boot. It is not a new boot method; it just supplies the files the existing `generic-extlinux-compatible` + U-Boot path needs.

When you build an SD image, the module sets `sdImage.populateFirmwareCommands` itself, so the firmware partition is populated at build time with no extra configuration.

For a running system, set `hardware.raspberry-pi.firmware.enable = true`. An activation script then repopulates the firmware partition on every `nixos-rebuild switch`. It is off by default.

To chainload U-Boot from the firmware, enable `uboot.enable`. It copies `u-boot.bin` to the firmware partition and sets `config.txt`'s `kernel` line for you:

```nix
{
  hardware.raspberry-pi.firmware = {
    enable = true;
    uboot.enable = true;
  };
}
```

`uboot.enable` defaults `uboot.package` to nixpkgs' `pkgs.ubootRaspberryPiAarch64`, built from the upstream `rpi_arm64_defconfig`, which covers every 64-bit board (Pi 3/4/5). For a 32-bit board, override `uboot.package` with the matching U-Boot build. On the Pi 5 this boots from SD, but U-Boot can't drive USB/PCIe/RP1 yet, so USB boot, NVMe boot, and a USB keyboard at the U-Boot prompt don't work until Linux takes over.

## `config.txt`

Board profiles import `hardware.raspberry-pi.configtxt`, which renders `config.txt` from Nix options. The defaults track the Raspberry Pi OS pi-gen image: camera and display autodetect, KMS, audio on, `arm_boost`.

```nix
{
  hardware.raspberry-pi.configtxt.settings = {
    all = {
      dtparam = [ "audio=on" ];
      dtoverlay = [
        "vc4-kms-v3d"
        "disable-bt"
      ];
    };
    pi5.arm_freq = 2400;
    cm4.otg_mode = true;
  };
}
```

List values become repeated keys in the rendered file, so the `dtoverlay` above expands to:

```
dtoverlay=vc4-kms-v3d
dtoverlay=disable-bt
```

Top-level attrs are conditional sections (`all`, `pi4`, `pi5`, `cm4`, and so on). Nesting stacks filters. To drop a default, set the key to `null` with `mkForce`.

## Current limits

- No bootloader module: There's no `boot.loader.raspberry-pi` here. Boards rely on `generic-extlinux-compatible` plus U-Boot. Raspberry Pi OS has the GPU firmware load the kernel directly; we go through U-Boot so it reads `extlinux.conf`, which is what gives you the NixOS boot-generation menu and rollbacks. The firmware install module just stages the boot code and (optionally) U-Boot; it doesn't add a firmware-level direct-boot path. Pi 5 boots from SD via U-Boot, but USB, PCIe, and the RP1 don't come up until Linux takes over, so a USB keyboard at the U-Boot prompt won't work on Pi 5 today.
- Single pinned kernel: `common/kernel.nix` pins one `linux-rpi` version rather than matching each kernel to its firmware release.
- No Pi 0/02/1 board profiles: `common/kernel.nix` accepts `rpiVersion = 1`, but there's no `0/`, `02/`, or `1/` directory wiring that kernel up into a profile you can import via `<nixos-hardware/raspberry-pi/...>`.
