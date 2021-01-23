# Derivatives for Microsoft Surface notebooks

These derivatives use the patches from the [linux-surface repo](https://github.com/linux-surface/linux-surface/tree/master/patches).

## Kernel

The kernel needs several patches to make it work correctly with some of the hardware on various
Surface models, e.g. keyboard/trackpad, camera, wifi.

Not all hardware is fully supported, but the
[linux-surface feature matrix](https://github.com/linux-surface/linux-surface/wiki/Supported-Devices-and-Features#feature-matrix)
provides details on which devices are supported on which types of machine.

The kernel-specific derivations are under the `kernel/` sub-directory.
In order to simplify maintenance of the Nix code, only the most-recent kernel patch-set is expected
to be maintained in this repo.

_*NOTE:*_Some built-in Kernel config items need to be set, that aren't set by default:
- https://github.com/linux-surface/surface-aggregator-module/wiki/Testing-and-Installing

## Firmware, Drivers and Support Tools

### WiFi

For the Surface Go, please see the "Issues" sections below.

### IPTS

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

*TODO*

# ToDo's Not Done

See: [TODO.org](./TODO.org)

# Issues

## TLP daemon

TLP is known to cause problems on Surface unless correctly configured.
See: https://github.com/linux-surface/linux-surface/blob/master/README.md

## Wifi Firmware for Surface Go

On the Surface Go, the standard firmware from the official Linux Firmware repo has issues with the
`ath10k` QCA6174 Wifi device.
You will see messages like "Can't ping firmware" *TODO - Copy messages from console*

The most effective fix to-date is to remove the `board-2.bin` file or replace it with a copy of the
`board.bin` file.

References:
- https://github.com/jakeday/linux-surface/issues/441
- https://www.reddit.com/r/SurfaceLinux/comments/e8quqg/surface_go_official_wifi_fix/
- https://hackmd.io/@dasgeek/ryA5i5Dor
- https://github.com/thebitstick/surfacego-wifi
- https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/ath10k
- https://wireless.wiki.kernel.org/en/users/drivers/ath10k/firmware
