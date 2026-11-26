# [Framework Laptop 12](https://frame.work/laptop12)

## Updating Firmware

Everything is updateable through fwupd, so it's enabled by default.

To get the latest firmware, run:

```sh
$ fwupdmgr refresh
$ fwupdmgr update
```

Currently no firmware update is available. Systems ship from the factory with the latest firmware.

## Touchscreen support in initrd (for unl0kr)

To unlock your LUKS disk encryption with an onscreen touch keyboard, you can use unl0kr.

This module will automatically included the necessary kernel modules in initrd to make touchpad and touchscreen work when `boot.initrd.unl0kr.enable = true`.

Example configuration:

```nix
{
  boot.initrd.systemd.enable = true;
  boot.initrd.unl0kr.enable = true;

  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/YOUR-UUID-HERE";
  };
}
```
