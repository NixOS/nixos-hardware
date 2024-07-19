> **NOTE**: This is an attempt to port [samueldr](https://github.com/samueldr/)'s [wip-pinebookpro](https://github.com/samueldr/wip-pinebook-pro) to [nixos-hardware](https://github.com/NixOS/nixos-hardware). Credit for the work done goes to the original authors.

## Using in your configuration

To use this configuration simply add this module to your configuration.

```nix
{
  imports = [
    ${nixos-hardware}/pine64/pinebook-pro
  ];
}
```

That entry point will try to maximize the hardware compatibility.

## Current state

Currently everything seems to work but this is not guaranteed it will be forever.

### Kernel

This module defaults to the latest upstream kernel. Attempts have been made to
use manjaro's kernel that makes the DP alt mode available over Type-C, but it
turns out that the kernel is unstable and some sporadic kernel panics may occur.
If you want to this kernel, you can grab the nix expression from this commit:
https://github.com/NixOS/nixos-hardware/blob/6d1bd5bc2e8b9992a3f57e416ba50fbed5516db6/pine64/pinebook-pro/kernel/default.nix

### Known issues

#### HDMI over Type-C

HDMI over Type-C works only for the custom kernel and the audio dosen't work (it's an upstream problem).

#### _EFI_ and poweroff

When booted using EFI, the system will not power off. It will stay seemingly
stuck with the LED and display turned off.

A [workaround exists](https://github.com/Tow-Boot/Tow-Boot/commit/818cae1b84a7702f2a509927f2819900c2881979#diff-20f50d9d8d5d6c059b87ad66fbc5df26d9fc46251763547ca9bdcc75564a4368),
and is built in recent Tow-Boot (make sure your release is 2021.10-004 or more recent).

### _Tow-Boot_

We highly suggest installing _Tow-Boot_ to the SPI Flash.

- https://github.com/Tow-Boot/Tow-Boot

Having the firmware installed to SPI makes the device act basically like a
normal computer. No need for weird incantations to setup the platform boot
firmware.

Alternatively, starting from the _Tow-Boot_ disk image on eMMC is easier to
deal with and understand than having to deal with _U-Boot_ manually.

### Mainline _U-Boot_

Mainline U-Boot has full support for graphics since 2021.04. The current
unstable relases of Nixpkgs are at 2021.04 at least.

```
 $ nix-build -A pkgs.ubootPinebookPro
```

Note that the default U-Boot build does not do anything with LED on startup.

## Keyboard firmware

> **WARNING**: Some hardware batches for the Pinebook Pro ship with the
> wrong chip for the keyboard controller. While it will work with the
> firmware it ships with, it _may brick_ while flashing the updated
> firmware. [See this comment on the firmware repository](https://github.com/jackhumbert/pinebook-pro-keyboard-updater/issues/33#issuecomment-850889285).
>
> It is unclear how to identify said hardware from a running system.

To determine which keyboard controller you have, you will need to disassemble
the Pinebook Pro as per [the Pine64
wiki](https://wiki.pine64.org/wiki/Pinebook_Pro#Keyboard), and make sure that
the IC next to the U23 marking on the main board is an **SH68F83**.

```sh
 $ nix-build -A pkgs.pinebookpro-keyboard-updater
 $ sudo ./result/bin/updater step-1 <iso|ansi>
 $ sudo poweroff
 # ...
 $ sudo ./result/bin/updater step-2 <iso|ansi>
 $ sudo poweroff
 # ...
 $ sudo ./result/bin/updater flash-kb-revised <iso|ansi>
```

Note: poweroff must be used, reboot does not turn the hardware "off" enough.
