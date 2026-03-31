# NextThingCo C.H.I.P / PocketCHIP

```nix
{
  inputs.nixpkgs.url = "https://nixos.org/channels/nixos-25.11/nixexprs.tar.xz";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware";
  outputs = { nixpkgs, nixos-hardware, ... }: {
    nixosConfigurations.ntcchip = nixpkgs.lib.nixosSystem {
      modules = [
        # If you are using C.H.I.P without PocketCHIP
        # nixos-hardware.nixosModules.nextthing-chip

        # If you are using PocketCHIP
        nixos-hardware.nixosModules.nextthing-chip-pocketchip

        "${nixos-hardware}/nextthing/chip/image.nix"

        {
          # Cross compilation build architecture
          nixpkgs.buildPlatform.system = "x86_64-linux";

          # Don't lock yourself out!
          services.openssh.enable = true;
          users.users.root = {
            initialPassword = "INSECURE CHANGE ME LATER";
            openssh.authorizedKeys.keys = [ "..." ];
          };
          networking.wireless.enable = true;
        }
      ];
    };
  };
}
```

## Try NixOS without wiping the stock OS

Build the image, then flash it to a USB thumbdrive:

```shellsession
$ nix build .#nixosConfigurations.ntcchip.config.system.build.sdImage -o result-image -vL
$ zstdcat ./result-image/sd-image/*.img.zst | sudo dd of=/dev/sdb status=progress
```

(It's called `sdImage` but we are not going to flash it to an SD card, just utilizing the `sdImage` infrastructure to build a flashable image.)

Plug the thumbdrive to your CHIP. Now we need to enter the "FEL mode". This can be achieved by connecting a jumper wire between the "FEL" pin and "GND" before boot, or pressing the `Reboot to FEL mode` button on the stock OS.

Now we can build our version of the bootloader and boot from it:

```shellsession
$ nix build .#nixosConfigurations.ntcchip.config.system.build.uboot -o result-uboot -vL
$ nix-shell -p sunxi-tools
[nix-shell]$ sudo sunxi-fel uboot ./result-uboot/u-boot-sunxi-with-spl.bin
```

The `sunxi-fel` command can fail complaining `ERROR: Allwinner USB FEL device not found!`. Simply try rerunning the command a few times more.

## Install U-Boot to NAND

The Allwinner R8 SoC itself can boot from NAND or SD cards (on PF or PC pins). However, this device does not have an SD card slot. In theory you could [add an SD card slot](https://byteporter.com/ntc-chip-micro-sd-slot/), but that's on the PE pins and the SoC cannot boot from it.

To make it boot without the help of a computer, we must install our bootloader to NAND. (WARNING: THIS WILL WIPE YOUR STOCK OS!)

Connect a USB-to-UART dongle to your CHIP (TXD->RXD, RXD->TXD, GND->GND), then run:

```shellsession
$ nix-shell -p picocom
[nix-shell]$ picocom -b 115200 /dev/ttyUSB0

Type [C-a] [C-h] to see available commands
Terminal ready
```

Short "FEL" to "GND", boot your CHIP. Open another shell session, run: (again these commands may fail, repeat the command when it fails)

```shellsession
$ nix-shell -p sunxi-tools
[nix-shell]$ sudo sunxi-fel spl result-uboot/sunxi-spl.bin
[nix-shell]$ sudo sunxi-fel write 0x4a000000 result-uboot/u-boot-dtb.bin
[nix-shell]$ sudo sunxi-fel write 0x43000000 result-uboot/sunxi-spl-with-ecc.bin
[nix-shell]$ sudo sunxi-fel exe 0x4a000000
```

Back to the `picocom` shell session, you should see this:

```shellsession
U-Boot SPL 2025.10 (Oct 06 2025 - 19:13:09 +0000)
DRAM: 512 MiB
CPU: 1008000000Hz, AXI/AHB/APB: 3/2/2
Trying to boot from FEL


U-Boot 2025.10 (Oct 06 2025 - 19:13:09 +0000) Allwinner Technology

CPU:   Allwinner A13 (SUN5I)
Model: NextThing C.H.I.P.
DRAM:  512 MiB
Core:  62 devices, 20 uclasses, devicetree: separate
WDT:   Not starting watchdog@1c20c90
NAND:  0 MiB
Loading Environment from nowhere... OK
DDC: timeout reading EDID
DDC: timeout reading EDID
DDC: timeout reading EDID
Setting up a 480x272 lcd console (overscan 0x0)
In:    serial,usbkbd
Out:   serial,vidconsole
Err:   serial,vidconsole
Allwinner mUSB OTG (Peripheral)
Net:   using musb-hdrc, OUT ep1out IN ep1in STATUS ep2in
MAC de:ad:be:ef:00:01
HOST MAC de:ad:be:ef:00:00
RNDIS ready
eth0: usb_ether

starting USB...
USB EHCI 1.00
USB OHCI 1.0
Bus usb@1c14000: 2 USB Device(s) found
Bus usb@1c14400: 1 USB Device(s) found
       scanning usb for storage devices... 1 Storage Device(s) found
Hit any key to stop autoboot: 2
```

Hit any key before it counts to 0 and you'll enter the U-Boot shell. Run:

```shellsession
=> nand erase.chip

NAND erase.chip: device 0 whole chip
Skipping bad block at  0x14800000
Skipping bad block at  0x15800000
Skipping bad block at  0xd7c00000
Skipping bbt reserved at  0xff000000
Skipping bbt reserved at  0xff400000
Skipping bbt reserved at  0xff800000
Skipping bbt reserved at  0xffc00000

OK
=> nand write.raw.noverify 0x43000000 0 40

NAND write:  1130496 bytes written: OK
=> nand write.raw.noverify 0x43000000 0x400000 40

NAND write:  1130496 bytes written: OK
=> nand write 0x4a000000 0x800000 0xc0000

NAND write: device 0 offset 0x800000, size 0xc0000
 786432 bytes written: OK
=> reset
resetting ...
```

## Install rootfs to NAND

This is not yet implemented, primarily due to the poor MLC NAND support on mainline Linux. In theory we could use SLC emulation mode to workaround this, like what [@macromorgan did with Debian 11](https://www.reddit.com/r/ChipCommunity/comments/pwhf37/mainline_debian_working_off_nand/). However, SLC emulation reduces usable storage by half (2 GiB), while a minimal NixOS install takes around 2.6 GiB.

## PocketCHIP Keyboard

[`pocketchip/default.nix`](./pocketchip/default.nix) adds an XKB keyboard layout for PocketCHIP. It should be automatically available under Xorg and Linux console. For Wayland composers, you have to configure it manually:

### Sway

```
input "1:1:tca8418" {
  xkb_layout us+pocketchip
}
```

### Niri

```kdl
input {
    keyboard {
        xkb {
            layout "us+pocketchip"
        }
    }
}
```

The Home/Power button sends `XF86PowerOff`. You can `disable-power-key-handling`, then bind it to something else:

```kdl
input {
    disable-power-key-handling
}
binds {
    XF86PowerOff repeat=false { toggle-overview; }
}
```
