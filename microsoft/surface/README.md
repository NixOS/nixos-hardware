# NOTE: Structure changes from 2023-01-10

Please read the [Deprecated Behaviour README](./OLD-BEHAVIOUR-DEPRECATION.md) to understand how some structural changes to
the code might affect you!

# Derivations for Microsoft Surface notebooks

These derivatives use the patches from the [linux-surface repo](https://github.com/linux-surface/linux-surface/tree/master/patches).

## Importing

By preference, there will already be a specialised module for your model's configuration.
e.g. The `microsoft/surface/surface-go` module configures for the Surface Go.

If not, the `microsoft/surface/common/` module can also be imported directly, and the options
provided can be used in your own system's configuration.

Alternatively, you can create a new specialisation for your model under `microsoft/surface`
configured for that model.

## Common Modules

Most shared / common modules are under the [`common/`](./common/) directory.
This includes the patched kernel build modules, as well as tools and service like `IPTSd` and `surface-control`.

### Kernel

The kernel needs several patches to make it work correctly with some of the hardware on various
Surface models, e.g. keyboard/trackpad, camera, wifi.

Not all hardware is fully supported, but the
[linux-surface feature matrix](https://github.com/linux-surface/linux-surface/wiki/Supported-Devices-and-Features#feature-matrix)
provides details on which devices are supported on which types of machine.

The kernel-specific derivations are under the [`common/kernel/`](./common/kernel/) sub-directory.
In order to simplify maintenance of the Nix code, only the most-recent kernel patch-set is expected
to be maintained in this repo.

_*NOTE:*_ Some built-in Kernel config items need to be set, that aren't set by default:
- https://github.com/linux-surface/surface-aggregator-module/wiki/Testing-and-Installing

### Support Tools

### IPTS

Enable this with the `microsoft-surface.ipts.enable = true;` config option.

IPTS is used on most of the Surface range, except for Surface Go and Surface Laptop 3 (AMD version).

Older kernels used specialised firmware which used a method that's no longer supported by the
more-recent kernels.

Newer kernels use the kernel-space `intel-precise-touch` driver and user-space `ipstd` daemon.

The `iptsd` daemon works with the `intel-precise-touch` driver to convert raw touch data from the
kernel-space driver into events for the HID / input sub-system.

- https://github.com/linux-surface/iptsd
- https://github.com/linux-surface/intel-precise-touch
  - _*NOTE:*_ The patches from this repo are included in the above kernel patches, already.

### DTX, `surface-control`

#### surface-control

Enable this with the `config.microsoft-surface.surface-control.enable = true;` config option.

For controlling the performance modes and other aspects of the device, the [`surface-control`](https://github.com/linux-surface/surface-control) tool is included.

To be able to control the performance mode without using `sudo`, add your user to the `surface-control` group.

## Firmware and Drivers

### WiFi on Surface Go

For the Surface Go, please see the "Issues" sections below.

Including the [`microsoft/surface/surface-go/firmware/ath-10k/`](./surface-go/firmware/ath-10k/)
module will replace the default firmware with the updated firmware.

# ToDo's Not Done

See: [TODO.org](./TODO.org)

# Issues

## TLP daemon

TLP is known to cause problems on Surface unless correctly configured.
See: https://github.com/linux-surface/linux-surface/blob/master/README.md

## Wifi Firmware for Surface Go

On the Surface Go, the standard firmware from the official Linux Firmware repo used to have issues
with the `ath10k` QCA6174 Wifi device.

This was fixed in Nov 2021:
- https://github.com/linux-surface/linux-surface/issues/542#issuecomment-976995453

### Background:

With the older firmware, you would see messages like "Can't ping firmware".

The most effective fix was to remove the `board-2.bin` file or replace it with a copy of the
`board.bin` file.

The derivative in `surface-go/firmware/ath10k/` can configure this, with the
`config.hardware.microsoft-surface.firmware.surface-go-ath10k.replace = true` config option.

_*NOTE:*_ This is destructive, as it deletes all the `board.bin` and `board-2.bin` files for the
`ath10k` QCA6174 device, and replaces them with KillerNetworking's version.
This is the only way (currently) to force the driver to use the new firmware.

For more details, see: https://github.com/linux-surface/linux-surface/wiki/Surface-Go#wifi-firmware

References:
- https://github.com/jakeday/linux-surface/issues/441
- https://www.reddit.com/r/SurfaceLinux/comments/e8quqg/surface_go_official_wifi_fix/
- https://hackmd.io/@dasgeek/ryA5i5Dor
- https://github.com/thebitstick/surfacego-wifi
- https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/ath10k
- https://wireless.wiki.kernel.org/en/users/drivers/ath10k/firmware
