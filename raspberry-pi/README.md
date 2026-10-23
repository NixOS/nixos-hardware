# Raspberry Pi

NixOS profiles and modules for Raspberry Pi boards.

## What's here

- `common/` has the shared bits: the `linux-rpi` kernel build (vendor defconfig, matching firmware), the `config.txt` generation module, a pinned wireless firmware, and the firmware-partition install module.
- The feature modules under `common/` configure audio, Bluetooth, DWC2, GPIO, I2C, and FKMS.
- `2/`, `3/`, `4/`, `5/` are the board profiles. Each one picks the right kernel and kernel params. Pi 4 and 5 also set DT filters and the initrd modules they need.
- The extra files under `4/` provide compatibility for older option names and support for custom DT merges.

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

These entries render in the `[pi4]` group:

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

A separate option is necessary because `settings` groups values by key. That grouping cannot keep an overlay next to the `dtparam` lines that belong to it. The order is functional. A `dtparam` applies to the overlay that loaded last, and the parameters of an overlay stay in scope only until the next overlay loads. The bare `dtoverlay=` line closes that scope, so later parameters apply to the base device tree. The order between overlays can also matter, because one overlay can build on another.

Overlays render after `settings`. This order keeps base parameters such as `dtparam=audio=on` out of the scope of an overlay. An overlay can export a parameter with the same name as a base parameter. While that overlay is in scope, the firmware uses the parameter of the overlay.

Each parameter becomes its own `dtparam` line rather than an addition to the `dtoverlay` line, which keeps them clear of the 98-character line limit. Booleans render as `on` or `off`. Use `null` with `mkForce` to remove a parameter.

The module concatenates lists from separate modules, but the order is not the order of definition. If one overlay must load before another, set the order with `mkBefore` or `mkAfter`.

For hardware-specific parameters, read the [Raspberry Pi overlay reference](https://github.com/raspberrypi/firmware/blob/master/boot/overlays/README).

To supply your own file, set `configtxt.file`. The module then ignores `settings` and `deviceTreeOverlays`.

#### Firmware boot configuration

The Raspberry Pi firmware applies overlays before U-Boot starts.
Set `boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false` so U-Boot passes the firmware-supplied tree to the kernel.
U-Boot then skips the device tree from the selected NixOS generation.
When NixOS rewrites `extlinux.conf`, this choice applies to all its generation entries.
The firmware supplies a tree at each boot, so firmware updates can change it.

Enabling `hardware.raspberry-pi.firmware.uboot.enable` sets this option automatically.
The audio, Bluetooth, DWC2, I2C, and FKMS modules also set it.

The firmware partition must contain the generated `config.txt` and stock overlays.
SD image builds populate it automatically.
On a running system, set `hardware.raspberry-pi.firmware.enable = true`.

`hardware.deviceTree.overlays` modifies a generation's DTBs (compiled descriptions of hardware).
Before using the firmware-supplied tree, migrate any changes that remain only in those DTBs.
The separate `hardware.raspberry-pi.firmware.useGenerationDeviceTree` option controls which DTBs the firmware installer copies.

### Firmware configuration modules

The board profiles import modules from `common/` for hardware-specific NixOS configuration, including firmware parameters and overlays.
Hardware support still depends on the board.
If you configure the same feature directly, disable its helper to avoid duplicate parameters or overlays.

#### Audio

To enable onboard audio through `snd_bcm2835` on Pi 2, 3, or 4:

```nix
{
  hardware.raspberry-pi.audio.enable = true;
}
```

The module sets `audio=on`, loads `snd_bcm2835`, and adds the headphone and HDMI kernel parameters.
NixOS [writes the extlinux `APPEND` line](https://github.com/NixOS/nixpkgs/blob/b1b875982b17dabde9b4a37f3e229e74913e6db3/nixos/modules/system/boot/loader/generic-extlinux-compatible/extlinux-conf-builder.sh#L78-L105) from each generation's kernel parameters.
The [audio driver](https://github.com/raspberrypi/linux/blob/stable_20260911/drivers/staging/vc04_services/bcm2835-audio/bcm2835.c) receives those parameters from this line.

The default KMS (kernel mode setting) overlay [provides HDMI audio](https://github.com/raspberrypi/firmware/blob/1.20260521/boot/overlays/README#L5994-L6014), so the module defaults `snd_bcm2835.enable_hdmi` to `0`.
For firmware-controlled displays, including FKMS, set `hardware.raspberry-pi.audio.hdmi.enable = true`.
The FKMS module supplies that default when it is enabled.

##### PulseAudio

When both `hardware.raspberry-pi.audio.enable` and `services.pulseaudio.enable` are `true`, the module adds `tsched=0` to PulseAudio's device-detection configuration.
This does not enable PulseAudio or change the sound server.
An explicit `services.pulseaudio.configFile` overrides this default.
To use the package's unmodified `default.pa`, set:

```nix
{ config, lib, ... }:

{
  services.pulseaudio.configFile =
    "${lib.getBin config.services.pulseaudio.package}/etc/pulse/default.pa";
}
```

#### DWC2

To enable the DWC2 USB controller in host mode:

```nix
{
  hardware.raspberry-pi.dwc2 = {
    enable = true;
    dr_mode = "host";
  };
}
```

`dr_mode` accepts `"host"`, `"peripheral"`, or `"otg"` and defaults to `"otg"`.
The [defaults](./common/config-txt-defaults.nix) enable the [XHCI host controller](https://www.raspberrypi.com/documentation/computers/config_txt.html#otg_mode) on CM4.
The DWC2 module sets `settings.cm4.otg_mode = null` to remove that default.

#### I2C

To enable I2C1 at 400 kHz, configure the bus:

```nix
{
  hardware.raspberry-pi.i2c1 = {
    enable = true;
    frequency = 400000;
  };
}
```

The modules enable `i2c-dev` and the `i2c` group through `hardware.i2c.enable`.
Both `i2c0.frequency` and `i2c1.frequency` use Hz and default to `null`, which keeps the firmware frequency.
The I2C0 module writes `dtparam=i2c0=on` to configure the base device tree.
It does not load `dtoverlay=i2c0`, because that [overlay](https://github.com/raspberrypi/firmware/blob/1.20260521/boot/overlays/README#L2680-L2697) changes pin routing and disables the multiplexer.

#### Bluetooth

To enable onboard Bluetooth through kernel discovery, set `hardware.raspberry-pi.bluetooth.enable = true`.
The module sets `krnbt=on` and enables `hardware.bluetooth.enable`.
If a custom `btattach` or `hciattach` service manages that controller, remove it.
Those services compete with kernel discovery to initialize the same controller.

#### GPIO

To give the `gpio` group access to GPIO devices, set `hardware.raspberry-pi.gpio.enable = true`.
The module also sets `iomem=relaxed` for pigpio's memory access.
It does not change device-tree selection.
Support for a particular board still depends on the GPIO library you use.

#### FKMS

The default KMS configuration lets the kernel control the display.
For firmware-assisted display control (FKMS) on Pi 2, 3, or 4, set `hardware.raspberry-pi.fkms-3d.enable = true`.
The module loads `vc4-fkms-v3d`, removes the default KMS overlay, and preserves the X11 driver order.
`hardware.raspberry-pi.fkms-3d.cma` uses MiB and defaults to `512`.
Remove any manually configured KMS overlays that match the same board.
Pi 5 does not support FKMS.

## Current limits

- No bootloader module: There's no `boot.loader.raspberry-pi` here. Boards rely on `generic-extlinux-compatible` plus U-Boot. Raspberry Pi OS has the GPU firmware load the kernel directly; we go through U-Boot so it reads `extlinux.conf`, which is what gives you the NixOS boot-generation menu and rollbacks. The firmware install module just stages the boot code and (optionally) U-Boot; it doesn't add a firmware-level direct-boot path. Pi 5 boots from SD via U-Boot, but USB, PCIe, and the RP1 don't come up until Linux takes over, so a USB keyboard at the U-Boot prompt won't work on Pi 5 today.
- Single pinned kernel: `common/kernel.nix` pins one `linux-rpi` version rather than matching each kernel to its firmware release.
- No Pi 0/02/1 board profiles: `common/kernel.nix` accepts `rpiVersion = 1`, but there's no `0/`, `02/`, or `1/` directory wiring that kernel up into a profile you can import via `<nixos-hardware/raspberry-pi/...>`.
