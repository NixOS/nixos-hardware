# [Framework Laptop 13](https://frame.work/)

## Updating Firmware

First put enable `fwupd`

```nix
services.fwupd.enable = true;
```

Then run

```sh
 $ fwupdmgr update
```

[Latest Update](https://fwupd.org/lvfs/devices/work.frame.Laptop.TGL.BIOS.firmware)
