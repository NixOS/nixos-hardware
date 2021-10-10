Kobol Helios64
==============

The `default.nix` module provides the required setup for the system to work.

The `recommended.nix` module adds recommended settings for the system.

Status
------

### Works

 - SATA hard drives
 - Ethernet (1gbps)
 - Serial through USB type-c (`ttyS2`)

### Untested

 - Ethernet (2.5gbps)
 - DP video out
 - UPS behaviour
 - `rootfs` on SATA drives

### Disabled

Due to misbehaviour, `ttyS0` (`&uart0`, `serial@ff180000`) has been disabled
via a kernel patch.

Without this change, using, or attempting to use `ttyS0` will break serial
output from `ttyS2`.


Kernel
------

Only Linux 5.10 (LTS) is supported, using the patch set derived from Armbian.


Requirements
------------

A *platform firmware* needs to be provided out of band for the system.

The author recommends Tow-Boot, for which a [draft pull request](https://github.com/Tow-Boot/Tow-Boot/pull/54)
adds support for the Helios64.

Any other supported *platform firmware* should work too.

> **NOTE**: at the time of writing (2021-10-10) the *platform firmware*
> **must** make use of the proprietary ram training. The open source equivalent
> will make the system unstable, and worse, will cause silent memory
> corruption, in addition to loud memory corruption.


Notes
-----

### Baud rate

The serial baud rate is configured for `115200`, which is a more common default
than the usual for Rockchip at `1500000`. See [the rationale for the decision](https://github.com/Tow-Boot/Tow-Boot/pull/33).

