# Purism Librem 5 revision 4

Purism's [Librem 5] is a privacy-oriented Linux-friendly smartphone.

[Librem 5]: https://puri.sm/products/librem-5/

## Installation procedure

> *Note*
>
> TODO: build a uuu-compatible installer.

Until there's a native installer, the easiest way to install NixOS on Librem 5 seems to be using [Jumpdrive].

[Jumpdrive]: https://github.com/dreemurrs-embedded/Jumpdrive

### Jumpdrive

Jumpdrive is a tiny Linux distribution which presents device's internal storage as USB mass storage when you connect it to a PC.
It also provides a shell session over telnet.

Follow the instructions in the repo to boot into Jumpdrive.
Note that `uuu` is part of `nxpmicro-mfgtools` package in nixpkgs.

Now, plug the device into your PC. A new block device representing Librem 5's internal MMC should appear in `/dev`.
Note down this device path.

### U-Boot

> **Note**
>
> While upstream u-boot does support Librem 5, it can only boot using `boot.scr`, for which NixOS has no native support.
>
> There's extlinux support in Librem 5's U-Boot here: https://source.puri.sm/Librem5/uboot-imx/
>
> This U-Boot version is packaged in the [`u-boot`] directory.


[`u-boot`]: ./u-boot

Provided you have a way to build Nix derivations for `aarch64-linux` (like a remote builder, [binfmt emulation], or you're building it on the phone itself), just run `nix-build u-boot/build.nix`.

[binfmt emulation]: https://search.nixos.org/options?channel=22.11&show=boot.binfmt.emulatedSystems&from=0&size=50&sort=relevance&type=packages&query=binfmt

> **Warning**
>
> Even though I've tested this myself, I can't guarantee that this will not render your device unbootable.
> Proceed with caution.
>
> If it does not work, your best bet is to follow the advice here, which will flash U-Boot build by upstream: https://forums.puri.sm/t/can-someone-with-serial-console-access-try-nixos-kernel-on-librem-5/19121/27

To flash u-boot to the device, use one of the following (assuming you've built u-boot to `./result`):

- if you're running an existing OS on the Librem 5, run `# result/bin/u-boot-install-librem5 /dev/mmcblk0` on the device itself
- if you've mounted the Librem 5's internal MMC via Jumpdrive, run `# TARGET="$(pwd)/result" result/bin/u-boot-install-librem5 <path to Librem 5's MMC>`
- if you want to flash u-boot manually (not recommended!), use `dd if=/dev/zero of=<path to MMC> bs=1024 count=1055 seek=2` and `dd if=result/uboot.imx conv=notrunc of=<path to MMC> bs=1024 seek=33`

At this point, if you have an OS installed on your Librem 5, it's best to reboot into it to check that the U-Boot was flashed correctly.
If that's the case, reboot back into Jumpdrive.

### Partitioning

Now, from your host system, partition the MMC.

> **Warning**
>
> Doing this wipes all data off the phone!

> **Warning**
>
> Make sure to keep 2MiB of free space before the first partition as this is where u-boot lives.
> If you accidentally create a file system in that space, you have to flash u-boot again.

It ended up looking like this (your device names will be different):

```console
$ sudo fdisk -l /dev/mmcblk0
Disk /dev/mmcblk0: 29,12 GiB, 31268536320 bytes, 61071360 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x15650736

Device         Boot  Start      End  Sectors  Size Id Type
/dev/mmcblk0p1 *      4096   528383   524288  256M 83 Linux
/dev/mmcblk0p2      528384 61071359 60542976 28,9G 83 Linux
```

Now you can create filesystems on those partitions.

I went with a bootable `ext2` partition for `/boot`, and one `f2fs` partition for `/`. You can use any filesystem supported by NixOS (like `ext4` or `zfs`) for `/`, but `f2fs` might improve your eMMC lifespan as it supports wear leveling. Note that `f2fs` does not have a journal, so filesystem corruption can happen if the battery runs out for example.

Mount the partitions on your host system, e.g. to `/mnt` and `/mnt/boot`.
Remember that `/mnt` is the second partition, and `/mnt/boot` is the first.

### Installation

Now, write your NixOS config.
Use `/dev/mmcblk0p1` as `fileSystems."/boot"` and `/dev/mmcblk0p2` as `fileSystems."/"`.
Don't forget to import the [module from this directory](./default.nix).
If you plan to use the device as a smartphone, you have a choice of two "desktop" (?) environments packaged in nixpkgs: [phosh] and [Plasma Mobile].

[phosh]: https://search.nixos.org/options?channel=22.11&show=services.xserver.desktopManager.phosh.enable&from=0&size=50&sort=relevance&type=packages&query=phosh
[Plasma Mobile]: https://search.nixos.org/options?channel=22.11&show=services.xserver.desktopManager.plasma5.mobile.enable&from=0&size=50&sort=relevance&type=packages

Build the configuration (`nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel` if you're using flakes).

Running `nixos-install --system ./result --root /mnt` will copy the system to the MMC.
Unless you're running on an aarch64 system, it will fail to activate or install the bootloader, however.
You must do this manually. Remember to `sync` and `umount` the MMC on your host before proceeding.
Get a shell on Jumpdrive, mount partitions there, and activate the system:

```console
$ nc 172.16.42.1 23
# mkdir /mnt
# mount /dev/mmcblk0p2 /mnt
# mkdir -p /mnt/boot
# mount /dev/mmcblk0p1 /mnt/boot
# chroot /mnt /nix/var/nix/profiles/system/activate
# chroot /mnt /nix/var/nix/profiles/system/bin/switch-to-configuration boot
```

Provided the last command succeeds, you now should have a bootable device.

Unmount:

```console
# sync
# umount /mnt/boot
# umount -l /mnt
# echo u > /proc/sysrq-trigger
# echo s > /proc/sysrq-trigger
```

And shut the phone down by holding the power key.

Start it up and you should be booting straight into your NixOS installation.

## Updating u-boot

Once you're running NixOS with this module, you can run `# u-boot-install-librem5 /dev/mmcblk0` any time to reflash the most recent version of u-boot from the running NixOS.

> **Warning**
>
> While I (@999eagle) will test u-boot updates on my own device before updating this repository, flashing u-boot may still render your device unbootable!
