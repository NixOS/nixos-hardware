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

## Getting the fingerprint sensor to work

The firmware on the fingerprint sensor needs a downgrade to make it work on Linux.
The process is documented [here](https://knowledgebase.frame.work/en_us/updating-fingerprint-reader-firmware-on-linux-for-13th-gen-and-amd-ryzen-7040-series-laptops-HJrvxv_za).

However on recent NixOS versions also fwupd can no longer update the firmware.
Using the following snippet allows to temporarly downgrade fwupd to an old-enough version:

```nix
{
  services.fwupd.enable = true;
  # we need fwupd 1.9.7 to downgrade the fingerprint sensor firmware
  services.fwupd.package = (import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/bb2009ca185d97813e75736c2b8d1d8bb81bde05.tar.gz";
    sha256 = "sha256:003qcrsq5g5lggfrpq31gcvj82lb065xvr7bpfa8ddsw8x4dnysk";
  }) {
    inherit (pkgs) system;
  }).fwupd;
}
```

Afterwards the downgraded driver can be downloaded and installed like this:

```
wget https://github.com/FrameworkComputer/linux-docs/raw/main/goodix-moc-609c-v01000330.cab
sudo fwupdtool install --allow-reinstall --allow-older goodix-moc-609c-v01000330.cab
Loading…                 [ -                                     ]/nix/store/1n2l5law9g3b77hcfyp50vrhhssbrj5g-glibc-2.37-8/lib/libc.so.6: version `GLIBC_2.38' not found (required by /nix/store/f55npw04a2s6xmrbx4jw12xq16b3avb8-gvfs-1.52.1/lib/gio/modules/libgvfsdbus.so)
Failed to load module: /nix/store/f55npw04a2s6xmrbx4jw12xq16b3avb8-gvfs-1.52.1/lib/gio/modules/libgvfsdbus.so
Loading…                 [                                       ]12:16:46.348 FuHistory            schema version 9 is unknown
Writing…                 [*************************************  ]12:16:57.055 FuEngine             failed to update-cleanup after failed update: failed to get device before update cleanup: failed to wait for detach replug: device d432baa2162a32c1554ef24bd8281953b9d07c11 did not come back

failed to write: failed to reply: transfer timed out
```

The error message above is harmless. After a reboot, I was able to enroll my fingerprint like this:

```
sudo fprintd-enroll $USER
```
