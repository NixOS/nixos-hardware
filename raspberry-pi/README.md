# Raspberry Pi

NixOS profiles and modules for Raspberry Pi boards.

## What's here

- `common/` has the shared bits: the `linux-rpi` kernel build (vendor defconfig, matching firmware), the `config.txt` generation module, a pinned wireless firmware, and the firmware-partition install module.
- `2/`, `3/`, `4/`, `5/` are the board profiles. Each one picks the right kernel and kernel params. Pi 4 and 5 also set DT filters and the initrd modules they need.
- The extra files under `4/` are opt-in toggles for Pi 4 hardware: audio, GPIO, I2C, LEDs, touchscreens, and so on.

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
      dtparam = [
        "audio=on"
        "i2c_arm=on"
      ];
      disable_overscan = true;
    };
    pi5.arm_freq = 2400;
    cm4.otg_mode = true;
  };
}
```

List values become repeated keys in the rendered file, so the `dtparam` above expands to:

```ini
dtparam=audio=on
dtparam=i2c_arm=on
```

Top-level attrs are conditional sections (`all`, `pi4`, `pi5`, `cm4`, and so on). Nesting stacks filters. Set a board profile's `mkDefault` value to `null` to remove it. Use `mkForce null` when overriding a value with normal priority.

Every rendered group opens with `[all]` and then its own filters. Filters of different types stack rather than replace, so `[all]` is what clears the previous group before the next one starts.

The firmware applies these filters at boot, not Nix at evaluation time. This matters in two cases. One image can boot on more than one board, such as a CM4 and a CM5 swapped into the same carrier. Filters like `[EDID=...]`, `[gpio4=1]`, `[tryboot]` and `[bootvar0=42]` also depend on state that Nix cannot see: the attached monitor, a jumper, an EEPROM value.

### Device tree overlays

Overlays go in `configtxt.deviceTreeOverlays`, not in a `dtoverlay` key under `settings`. Filters nest the same way, and the leaf is an ordered list where each element names one overlay and its parameters:

```nix
{
  boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;

  hardware.raspberry-pi.configtxt.deviceTreeOverlays.pi4 = [
    { dwc2.dr_mode = "host"; }
    {
      gpio-fan = {
        gpiopin = 14;
        temp = 80000;
      };
    }
  ];
}
```

This renders after `configtxt.settings` as:

```ini
[all]
[pi4]
dtoverlay=dwc2
dtparam=dr_mode=host
dtoverlay=
dtoverlay=gpio-fan
dtparam=gpiopin=14
dtparam=temp=80000
dtoverlay=
```

A separate option is necessary because `settings` groups values by key. That grouping cannot keep an overlay next to the `dtparam` lines that belong to it. The order is functional. A `dtparam` applies to the overlay that loaded last, and the parameters of an overlay stay in scope only until the next overlay loads. The bare `dtoverlay=` line closes that scope, so later parameters apply to the base device tree. The order between overlays can also matter, because one overlay can build on another.

Overlays render after `settings`. This order keeps base parameters such as `dtparam=audio=on` out of the scope of an overlay. An overlay can export a parameter with the same name as a base parameter. While that overlay is in scope, the firmware uses the parameter of the overlay.

Each parameter becomes its own `dtparam` line rather than an addition to the `dtoverlay` line, which keeps them clear of the 98-character line limit. Booleans render as `on` or `off`. Use `null` with `mkForce` to remove a parameter.

The module concatenates lists from separate modules, but the order is not the order of definition. If one overlay must load before another, set the order with `mkBefore` or `mkAfter`.

The Raspberry Pi firmware applies these overlays before U-Boot starts. Set `boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false` so U-Boot keeps that device tree instead of loading one from the NixOS generation. Enabling `hardware.raspberry-pi.firmware.uboot.enable` sets this automatically.

The firmware partition must contain the generated `config.txt` and stock overlays. SD image builds populate it automatically. On a running system, set `hardware.raspberry-pi.firmware.enable = true`.

#### DWC2 USB controller

Use the stock `dwc2` overlay to enable the USB 2.0 controller on the Pi 4B USB-C connector:

```nix
{
  hardware.raspberry-pi.configtxt.deviceTreeOverlays."board-type=0x11" = [
    { dwc2 = { }; }
  ];
}
```

`board-type=0x11` matches the Pi 4B. The broader `pi4` filter also matches Pi 400, CM4, and CM4S.

[Raspberry Pi OS sets `otg_mode=1` on CM4](https://github.com/RPi-Distro/pi-gen/blob/master/stage1/00-boot-files/files/config.txt#L39-L43), and [nixos-hardware sets the same default](./common/config-txt-defaults.nix). Set it to `null` before loading DWC2:

```nix
{
  hardware.raspberry-pi.configtxt = {
    settings.cm4.otg_mode = null;
    deviceTreeOverlays.cm4 = [
      { dwc2 = { }; }
    ];
  };
}
```

The `cm4` filter matches CM4 only. Set `dwc2.dr_mode` to `host`, `peripheral`, or `otg` to override the overlay default. The overlay also accepts `g-rx-fifo-size` and `g-np-tx-fifo-size`.

#### PoE HATs

The original [PoE HAT](https://www.raspberrypi.com/products/poe-hat/) and the [PoE+ HAT](https://www.raspberrypi.com/products/poe-plus-hat/) use the stock `rpi-poe` and `rpi-poe-plus` overlays. Both HATs support the Pi 3B+ and Pi 4B.

```nix
{
  hardware.raspberry-pi.configtxt.deviceTreeOverlays."board-type=0x11" = [
    {
      rpi-poe = {
        poe_fan_temp0 = 50000;
        poe_fan_temp0_hyst = 2000;
      };
    }
  ];
}
```

Use `board-type=0x0d` for the Pi 3B+ and `board-type=0x11` for the Pi 4B. Replace `rpi-poe` with `rpi-poe-plus` for the PoE+ HAT. All overlay parameters are optional.

To supply your own file, set `configtxt.file`. The module then ignores `settings` and `deviceTreeOverlays`.

## Current limits

- No bootloader module: There's no `boot.loader.raspberry-pi` here. Boards rely on `generic-extlinux-compatible` plus U-Boot. Raspberry Pi OS has the GPU firmware load the kernel directly; we go through U-Boot so it reads `extlinux.conf`, which is what gives you the NixOS boot-generation menu and rollbacks. The firmware install module just stages the boot code and (optionally) U-Boot; it doesn't add a firmware-level direct-boot path. Pi 5 boots from SD via U-Boot, but USB, PCIe, and the RP1 don't come up until Linux takes over, so a USB keyboard at the U-Boot prompt won't work on Pi 5 today.
- Single pinned kernel: `common/kernel.nix` pins one `linux-rpi` version rather than matching each kernel to its firmware release.
- No Pi 0/02/1 board profiles: `common/kernel.nix` accepts `rpiVersion = 1`, but there's no `0/`, `02/`, or `1/` directory wiring that kernel up into a profile you can import via `<nixos-hardware/raspberry-pi/...>`.
