# Description

This document on how I configure [NixOS](https://nixos.org/) on [NanoPC-T4](https://wiki.friendlyarm.com/wiki/index.php/NanoPC-T4).

# Installation

To install NixOS on you can follow the [official instructions](https://wiki.nixos.org/wiki/NixOS_on_ARM/NanoPC-T4) and use the [pre-built images](https://github.com/tmountain/arch-nanopct4/tree/main/images/) from @tmountain. You can also build the U-Boot image yourself from `nixpkgs` based on changes added in [#111034](https://github.com/NixOS/nixpkgs/pull/111034).

## NixOS on NVMe with ZFS

It is possible to migrate the OS from the eMMC storage to the NVMe.

In my case I migrated `/`, `/nix`, and `/home`, leaving `/boot` on the eMMC.

Create the ZFS pool and three filesystems on the SSD:
```sh
zpool create -O xattr=sa -O acltype=posixacl -O mountpoint=none rpool /dev/nvme0n1
for VOL in nix root home; do
    zfs create -o mountpoint=legacy rpool/$VOL
    mkdir /mnt/$VOL
    mount.zfs rpool/$VOL /mnt/$VOL
done
```
Then sync the original filesystem on eMMC to the new volumes:
```sh
rsync -rax /. /mnt/root
rsync -rax /nix/. /mnt/nix
rsync -rax /home/. /mnt/home
rsync -rax /boot/. /
```
Afterwards create a configuration that looks like this:
```nix
{
  # TODO: Make sure to update the eMMC device UUID!
  fileSystems."/boot" = { device = "/dev/disk/by-uuid/1234-5678"; fsType = "ext4"; };
  fileSystems."/" = { device = "rpool/root"; fsType = "zfs"; };
  fileSystems."/nix" = { device = "rpool/nix"; fsType = "zfs"; };
  fileSystems."/home" = { device = "rpool/home"; fsType = "zfs"; };
}
```
And rebuild he system:
```sh
sudo nixos-rebuild boot
```
:warning: __IMPORTANT:__ After that it's necessary to run all the four `rsync` commands again to sync filesystems.

Once everything is synced you can finally reboot.

You should also clean up `/boot` afterwards.

# UART Debug Console

Device provides a Debug UART 4 Pin 2.54mm header connection, 3V level, 1500000bps.

To connect to you will need a USB to UART converter/receiver that supports the speed of 1500000bps.

The serial port parameters are [8-N-1](https://en.wikipedia.org/wiki/8-N-1).

A reader using `CP2102` chip did not work but `FT232RL` works fine:

![UART converter photo](https://github.com/NixOS/nixos-hardware/releases/download/not-a-release/FT232RL.jpg)

You can use `minicom` or `picocom` to connect:
```
sudo minicom -b 1500000 -D /dev/ttyUSB0
sudo picocom -b 1500000 /dev/ttyUSB0
```
But you'll need to disable flow control with `Ctrl-A x`.

Here is a good overview of UART USB-to-Serial adapters:

* https://www.sjoerdlangkemper.nl/2019/03/20/usb-to-serial-uart/
* https://www.ftdichip.com/Support/Documents/DataSheets/ICs/DS_FT232R.pdf

Pin layout where #4 is next to USB-C port:

| Pin num.| #1  | #2 | #3 | #4 |
|---------|-----|----|----|----|
| Purpose | GND | V5 | TX | RX |

Remember that the `TX` and `RX` ports should be swapped between UART adapter and the board.

The V5 pin does not need to be connected if you're powering the board from another source.

See the full board diagram for more details:

![Board diagram](https://wiki.friendlyarm.com/wiki/images/b/bb/NanoPC-T4_1802_Drawing.png)

You can access the recovery console by holding the __Recovery__ button and then pressing the __Power__ button.
For this to work the device will have to be off, which requires holding the __Power__ button long enough.

