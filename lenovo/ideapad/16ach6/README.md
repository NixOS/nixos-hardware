# Lenovo IdeaPad 5 Pro 16ACH6

This laptop comes with an AMD CPU+GPU and dedicated NVIDIA graphics. Unlike the similarly named [Legion 5 Pro 16ACH6*H*](../../legion/16ach6h/), there is no direct dedicated graphics setting.

The `nvidia.hardware.powerManagement.enable` option is not enabled in this configuration, since it seemed to cause issues when waking up from suspend, while also not providing much in terms of power saving. I've tested with `finegrained` both enabled and disabled, and it caused the screen to go dark a few moments after waking up from suspend. Most times this only happened once and the screen came back after a few moments, but on some occasions it kept occurring repeatedly.

This device also has a "battery conservation mode", which charges the battery to only ~60%. This mode can be enabled using [TLP](https://linrunner.de/tlp/settings/bc-vendors.html#lenovo-non-thinkpad-series):

```nix
services.power-profiles-daemon.enable = false;
services.tlp.enable = true;
services.tlp.settings = {
  # Enable battery conservation mode
  # Run `sudo tlp fullcharge` to enable a full charge until next reboot,
  # and `sudo tlp setcharge` to reset to conservation mode.
  START_CHARGE_THRESH_BAT0 = 0;
  STOP_CHARGE_THRESH_BAT0 = 1;
};
```

## Device information

Details from `tlp-stat`:

```
System         = LENOVO IdeaPad 5 Pro 16ACH6 82L5
BIOS           = GSCN35WW
EC Firmware    = 1.35
OS Release     = NixOS 23.11 (Tapir)
Kernel         = 6.6.10 #1-NixOS SMP PREEMPT_DYNAMIC Fri Jan  5 14:19:45 UTC 2024 x86_64
Init system    = systemd
Boot mode      = UEFI
Suspend mode   = [s2idle]
```

`lspci` output:

```
01:00.0 3D controller: NVIDIA Corporation GA107M [GeForce RTX 3050 Mobile] (rev a1)
05:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Cezanne [Radeon Vega Series / Radeon Vega Mobile Series] (rev c4)
```
