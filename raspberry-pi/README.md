# Raspberry Pi

NixOS profiles and modules for Raspberry Pi boards.

## What's here

- `common/` has the shared bits: the `linux-rpi` kernel build (vendor defconfig, matching firmware), the `config.txt` generation module, a pinned wireless firmware, and the firmware-partition install module.
- `1/`, `2/`, `3/`, `4/`, `5/` are the board profiles.
  They select vendor kernels and configure board-specific boot and hardware settings.
  Pi 4 and 5 also set DT filters and the initrd modules they need.
- The extra files under `4/` are opt-in toggles for Pi 4 hardware: audio, GPIO, I2C, LEDs, touchscreens, and so on.
- Where provided, `sd-image.nix` and `sd-image-installer.nix` combine a board profile with nixpkgs' SD-image builder, optionally adding the NixOS installation environment.

## Using a board profile

```nix
{
  imports = [
    <nixos-hardware/raspberry-pi/4>
  ];
}
```

These profiles assume the `generic-extlinux-compatible` bootloader (the NixOS module that writes an `extlinux.conf` for U-Boot to read), which is what aarch64 NixOS SD images use by default.
There is no `boot.loader.raspberry-pi` module here.
U-Boot and the GPU boot code still have to land on the firmware partition somehow: either your image builder does it, or you use the firmware install module below.

## Firmware install

`hardware.raspberry-pi.firmware` stages the files the Pi firmware needs before Linux starts onto the firmware partition (default `/boot/firmware`): GPU boot code (`bootcode.bin`, `start*.elf`, `fixup*.dat`), vendor device trees and overlays, the rendered `config.txt`, and optionally U-Boot.
It is not a new boot method; it just supplies the files the existing `generic-extlinux-compatible` + U-Boot path needs.

When you build an SD image, the module sets `sdImage.populateFirmwareCommands` itself, so the firmware partition is populated at build time with no extra configuration.
For cross-compilation, set `nixpkgs.buildPlatform` to the build machine's architecture and `nixpkgs.hostPlatform` to the target board's architecture, unless the profile already selects it.

For a running system, set `hardware.raspberry-pi.firmware.enable = true`.
An activation script then repopulates the firmware partition on every `nixos-rebuild switch`.
It is off by default.

To chainload U-Boot from the firmware, enable `uboot.enable`.
It copies `u-boot.bin` to the firmware partition and sets `config.txt`'s `kernel` line for you:

```nix
{
  hardware.raspberry-pi.firmware = {
    enable = true;
    uboot.enable = true;
  };
}
```

The shared firmware module defaults `uboot.package` to `pkgs.ubootRaspberryPiAarch64`, built from `rpi_arm64_defconfig` for 64-bit Pi 3/4/5 systems.
Board profiles can override this default.
For 32-bit systems, use the package matching the board: `pkgs.ubootRaspberryPi` for Pi 1, `pkgs.ubootRaspberryPi2` for Pi 2, or `pkgs.ubootRaspberryPi3_32bit` for Pi 3.
On the Pi 5 this boots from SD, but U-Boot can't drive USB/PCIe/RP1 yet, so USB boot, NVMe boot, and a USB keyboard at the U-Boot prompt don't work until Linux takes over.

## `config.txt`

Board profiles import `hardware.raspberry-pi.configtxt`, which renders `config.txt` from Nix options.
The Pi 2–5 profiles also import `common/config-txt-defaults.nix`, which tracks the Raspberry Pi OS pi-gen image: camera and display autodetect, KMS, audio on, `arm_boost`.

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

Top-level attrs are conditional sections (`all`, `pi4`, `pi5`, `cm4`, and so on).
Nesting stacks filters.
Set a board profile's `mkDefault` value to `null` to remove it.
Use `mkForce null` when overriding a value with normal priority.

Every rendered group opens with `[all]` and then its own filters.
Filters of different types stack rather than replace, so `[all]` is what clears the previous group before the next one starts.

The firmware applies these filters at boot, not Nix at evaluation time.
This matters in two cases.
One image can boot on more than one board, such as a CM4 and a CM5 swapped into the same carrier.
Filters like `[EDID=...]`, `[gpio4=1]`, `[tryboot]` and `[bootvar0=42]` also depend on state that Nix cannot see: the attached monitor, a jumper, an EEPROM value.

### Device tree overlays

Before switching to the firmware-provided device tree, migrate other `hardware.deviceTree.overlays` to `hardware.raspberry-pi.configtxt`.

Overlays go in `configtxt.deviceTreeOverlays`, not in a `dtoverlay` key under `settings`.
Filters nest the same way, and the leaf is an ordered list where each element names one overlay and its parameters:

```nix
{
  boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;

  hardware.raspberry-pi.configtxt.deviceTreeOverlays.pi4 = [
    {
      gpio-fan = {
        gpiopin = 12;
        temp = 80000;
      };
    }
    {
      gpio-led = {
        gpio = 16;
        label = "status";
      };
    }
  ];
}
```

This renders after `configtxt.settings` as:

```ini
[all]
[pi4]
dtoverlay=gpio-fan
dtparam=gpiopin=12
dtparam=temp=80000
dtoverlay=
dtoverlay=gpio-led
dtparam=gpio=16
dtparam=label=status
dtoverlay=
```

A separate option is necessary because `settings` groups values by key.
That grouping cannot keep an overlay next to the `dtparam` lines that belong to it.
The order is functional.
A `dtparam` applies to the overlay that loaded last, and the parameters of an overlay stay in scope only until the next overlay loads.
The bare `dtoverlay=` line closes that scope, so later parameters apply to the base device tree.
The order between overlays can also matter, because one overlay can build on another.

Overlays render after `settings`.
This order keeps base parameters such as `dtparam=audio=on` out of the scope of an overlay.
An overlay can export a parameter with the same name as a base parameter.
While that overlay is in scope, the firmware uses the parameter of the overlay.

Each parameter becomes its own `dtparam` line rather than an addition to the `dtoverlay` line, which keeps them clear of the 98-character line limit.
Booleans render as `on` or `off`.
Use `null` with `mkForce` to remove a parameter.

The module concatenates lists from separate modules, but the order is not the order of definition.
If one overlay must load before another, set the order with `mkBefore` or `mkAfter`.

For overlay names and hardware-specific parameters, use the [Raspberry Pi overlay reference](https://github.com/raspberrypi/linux/blob/rpi-6.18.y/arch/arm/boot/dts/overlays/README).

The Raspberry Pi firmware applies these overlays before U-Boot starts.
Set `boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false` so U-Boot keeps that device tree instead of loading one from the NixOS generation.
Enabling `hardware.raspberry-pi.firmware.uboot.enable` sets this automatically.

The firmware partition must contain the generated `config.txt` and stock overlays.
SD image builds populate it automatically.
On a running system, set `hardware.raspberry-pi.firmware.enable = true`.

To supply your own file, set `configtxt.file`.
The module then ignores `settings` and `deviceTreeOverlays`.

#### Overriding board defaults

The shared board defaults are defined in [`common/config-txt-defaults.nix`](./common/config-txt-defaults.nix) with `lib.mkDefault`.
Set a `hardware.raspberry-pi.configtxt.settings` value to `null` to omit that default from the generated `config.txt`.
For example, to remove the default `otg_mode` setting before loading `dwc2` on CM4, use:

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

## Audio

To enable the headphone jack on Raspberry Pi 2, 3, or 4:

```nix
{
  hardware.raspberry-pi.audio.enable = true;
}
```

The audio module loads the [`snd_bcm2835` kernel module](https://github.com/raspberrypi/linux/blob/rpi-6.18.y/drivers/staging/vc04_services/bcm2835-audio/bcm2835.c) to enable headphone audio.
If you use PulseAudio, the module also provides a default configuration to avoid audio glitches.

## FKMS

The default KMS configuration lets the kernel control the display.
For firmware-assisted display control (FKMS) on Pi 2, 3, or 4:

```nix
{
  hardware.raspberry-pi.fkms-3d.enable = true;
}
```

The board profiles import this module from `common/modesetting.nix`.
It loads `vc4-fkms-v3d`, removes the default KMS overlay, and preserves the X11 driver order.
`hardware.raspberry-pi.fkms-3d.cma` uses MiB and defaults to `512`.
Remove any manually configured KMS overlays that match the same board.
Pi 5 does not support FKMS.

With FKMS enabled, use the audio module and this kernel parameter for HDMI audio:

```nix
{
  hardware.raspberry-pi.audio.enable = true;
  boot.kernelParams = [ "snd_bcm2835.enable_hdmi=1" ];
}
```

The module selects the firmware-provided device tree.
Before enabling it, migrate changes that exist only in a generation's `hardware.deviceTree.overlays`.
See "Device tree overlays" above for firmware installation.

## Current limits

- No bootloader module: There's no `boot.loader.raspberry-pi` here.
  Boards rely on `generic-extlinux-compatible` plus U-Boot.
  Raspberry Pi OS has the GPU firmware load the kernel directly; we go through U-Boot so it reads `extlinux.conf`, which is what gives you the NixOS boot-generation menu and rollbacks.
  The firmware install module just stages the boot code and (optionally) U-Boot; it doesn't add a firmware-level direct-boot path.
  Pi 5 boots from SD via U-Boot, but USB, PCIe, and the RP1 don't come up until Linux takes over, so a USB keyboard at the U-Boot prompt won't work on Pi 5 today.
- Single pinned kernel: `common/kernel.nix` pins one `linux-rpi` version rather than matching each kernel to its firmware release.
- No Pi Zero or Zero 2 board profiles.
