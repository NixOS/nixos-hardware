# [Framework Desktop](https://frame.work/desktop)

## Kernel version

The recommended version is 6.15 or newer, it has good GPU and also EC firmware support (for sensors and ARGB).
The lowest recommended version is 6.14. It has good GPU support already.
The absolute lowest that runs okay on headless systems is 6.11, but the GPU is not fully supported yet.

## Updating Firmware

First put enable `fwupd`

```nix
services.fwupd.enable = true;
```

Then run

```sh
 $ fwupdmgr update
```

- [Latest Update](https://fwupd.org/lvfs/devices/work.frame.Desktop.RyzenAIMax300.BIOS.firmware)
