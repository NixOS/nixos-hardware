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

As of firmware v03.03, a bug in the EC causes the system to wake if AC is connected _despite_ the lid being closed. The following works around this, with the trade-off that keyboard presses also no longer wake the system.

```nix
services.udev.extraRules = ''
# Prevent wake when plugging in AC during suspend. Trade-off: keyboard wake disabled. See:
# https://community.frame.work/t/tracking-framework-amd-ryzen-7040-series-lid-wakeup-behavior-feedback/39128/45
ACTION=="add", SUBSYSTEM=="serio", DRIVERS=="atkbd", ATTR{power/wakeup}="disabled"
'';
```

See [Framework AMD Ryzen 7040 Series lid wakeup behavior feedback](https://community.frame.work/t/tracking-framework-amd-ryzen-7040-series-lid-wakeup-behavior-feedback/39128/45).
