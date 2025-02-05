# NOTE: Structure changes from 2023-11-11

Please read the [Deprecated Behaviour README](./OLD-BEHAVIOUR-DEPRECATION.md) to understand how some structural changes to
the code might affect you!

# [Framework Laptops](https://frame.work/)

## Updating Firmware

First put enable `fwupd`

```nix
services.fwupd.enable = true;
```

> [!Note]
> For Intel CPU's, even [stable BIOS versions](https://community.frame.work/t/responded-11th-gen-intel-core-bios-3-17-release/25137#update-april-11-2023-2) are currently marked as [test versions](https://fwupd.org/lvfs/devices/work.frame.Laptop.TGL.BIOS.firmware) in LVFS (the default remote fwupd uses to get firmware).
>
> If you want to use these versions, you'll have to [explicitly enable the lvfs-testing remote](https://community.frame.work/t/responded-11th-gen-intel-core-bios-3-17-release/25137#linuxlvfs-7):
>
> ```nix
> services.fwupd.extraRemotes = [ "lvfs-testing" ];
> # Might be necessary once to make the update succeed
> services.fwupd.uefiCapsuleSettings.DisableCapsuleUpdateOnDisk = true;
> ```

> [!Caution]
> Before running the update, make sure you have a [NixOS live ISO](https://nixos.org/download/#nixos-iso) on a USB stick, because some firmware updates [make your system unbootable](https://community.frame.work/t/drive-not-bootable-after-bios-update/12887).

Then run

```sh
 $ fwupdmgr update
```

If you cannot boot into your system after upgrading:
1. Boot into the live USB
2. Mount your system into `/mnt`
3. Run
   ```
   sudo nixos-enter
   ```
4. Run
   ```
   NIXOS_INSTALL_BOOTLOADER=1 /run/current-system/bin/switch-to-configuration boot
   ```

## Common Modules

For the Framework 13 laptops, there are common configuration modules available under the `13-inch/common/` directory,
including some modules specific to AMD- or Intel-based laptops. By preference, there will already be a specialised
module for your model's configuration. Otherwise, it can be added alongside the existing modules.

## OS integration

`hardware.framework.enableKmod` enables the [community-created Framework kernel
module](https://github.com/DHowett/framework-laptop-kmod) which exposes EC functionality like battery charge limit,
privacy switches, and system LEDs as standard driver interfaces. This enables, for example, configuring the charge limit
using the KDE settings GUI. The option is enabled by default when NixOS `>= 24.05` and linux kernel version `>= 6.10`.

On AMD Framework 13 and 16, before kernel 6.10, additional kernel patches are required for the kernel module to function
properly. Manually setting `hardware.framework.enableKmod = true` will apply the patches, requiring a kernel
recompilation.

## Support Tools

### fw-ectool

There is a `fw-ectool` package available in nixpkgs that provides some system configuration options via the EC.
This ectool only works with the Intel-based Framework laptops at present, as the Framework EC for AMD-based mainboards
is based on the Zephyr port of the ChromeOS EC, which involves a slightly changed communication interface.
