# Raspberry Pi

NixOS profiles and modules for Raspberry Pi boards.

## What's here

- `common/` has the shared bits: the `linux-rpi` kernel build (vendor defconfig, matching firmware), the `config.txt` generation module, and a pinned wireless firmware.
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

These profiles assume the `generic-extlinux-compatible` bootloader (the NixOS module that writes an `extlinux.conf` for U-Boot to read), which is what aarch64 NixOS SD images use by default. There is no `boot.loader.raspberry-pi` module here. U-Boot itself still has to land on the boot partition somehow. Either your image builder does it, or you do. Nothing in here writes to `/boot/firmware/`. See [Current limits](#current-limits).

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

- No firmware install: Nothing writes `start*.elf`, `bootcode.bin`, `fixup*.dat`, vendor DTBs, overlays, or `config.txt` to `/boot/firmware/`. The rendered config.txt is exposed at `hardware.raspberry-pi.configtxt.file`, but nothing on disk reads it yet. You either rely on the SD-image populate step or stage those files yourself.
- No bootloader module: There's no `boot.loader.raspberry-pi` here. Boards rely on `generic-extlinux-compatible` plus U-Boot. Pi 5 boots from SD via U-Boot, but USB, PCIe, and the RP1 don't come up until Linux takes over. So a USB keyboard at the U-Boot prompt won't work on Pi 5 today.
- No Pi 0/02/1 board profiles: `common/kernel.nix` accepts `rpiVersion = 1`, but there's no `0/`, `02/`, or `1/` directory wiring that kernel up into a profile you can import via `<nixos-hardware/raspberry-pi/...>`.
