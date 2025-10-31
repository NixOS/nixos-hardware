# [Framework Laptop 16 AMD AI 300 Series](https://frame.work/)

## nvidia

If you have an nvidia dGPU module, you can enable it via the nvidia open drivers:

```
services.xserver.videoDrivers = [ "nvidia" ];
hardware.nvidia.open = true;  # see the note above
```

See also [NVIDIA](https://wiki.nixos.org/wiki/NVIDIA) on the NixOS Wiki.

## Updating Firmware

Everything is updateable through fwupd, so it's enabled by default.

To get the latest firmware, run:

```sh
$ fwupdmgr refresh
$ fwupdmgr update
```

- [Latest Update](https://fwupd.org/lvfs/devices/work.frame.Laptop16.RyzenAI300.BIOS.firmware)
