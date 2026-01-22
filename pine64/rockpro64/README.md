# Pine64 RockPro64

## _Tow-Boot_

We highly suggest installing _Tow-Boot_ to the SPI Flash.

- https://github.com/Tow-Boot/Tow-Boot

Having the firmware installed to SPI makes the device act basically like a
normal computer. No need for weird incantations to setup the platform boot
firmware.

Alternatively, starting from the _Tow-Boot_ disk image on eMMC is easier to
deal with and understand than having to deal with _U-Boot_ manually.

## Console

To configure default console I/O to use serial instead of HDMI (default):

```nix
hardware.rockpro64.console = "serial";
```
