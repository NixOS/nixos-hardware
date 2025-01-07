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

- [Latest Update](https://fwupd.org/lvfs/devices/work.frame.Laptop.Ryzen7040.BIOS.firmware)

## Suspend/wake workaround

As of firmware v03.03, a bug in the EC causes the system to wake if AC is connected _despite_ the lid being closed. A workaround has been [upstreamed](https://github.com/torvalds/linux/commit/a55bdad5dfd1efd4ed9ffe518897a21ca8e4e193) in Linux v6.7. For older kernels, the following works around this, with the trade-off that keyboard presses also no longer wake the system.

```nix
{
  hardware.framework.amd-7040.preventWakeOnAC = true;
}
```

See [Framework AMD Ryzen 7040 Series lid wakeup behavior feedback](https://community.frame.work/t/tracking-framework-amd-ryzen-7040-series-lid-wakeup-behavior-feedback/39128/45).
