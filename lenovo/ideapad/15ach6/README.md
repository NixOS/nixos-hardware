# Lenovo IdeaPad Gaming 3 15ACH6

This device supports "battery conservation mode", which charges the battery to only ~60%. This mode can be enabled using [TLP](https://linrunner.de/tlp/settings/bc-vendors.html#lenovo-non-thinkpad-series):

## Device information

Details from `tlp-stat`:

```
System         = LENOVO IdeaPad Gaming 3 15ACH6 82K2
BIOS           = H3CN31WW(V2.01)
EC Firmware    = 1.31
OS Release     = NixOS 24.11 (Vicuna)
Kernel         = 6.6.37 #1-NixOS SMP PREEMPT_DYNAMIC Fri Jul  5 07:34:07 UTC 2024 x86_64
Init system    = systemd 
Boot mode      = UEFI
Suspend mode   = s2idle [deep]
```

`lspci` output:

```
01:00.0 3D controller: NVIDIA Corporation GA106M [GeForce RTX 3060 Mobile / Max-Q] (rev a1)
06:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Cezanne [Radeon Vega Series / Radeon Vega Mobile Series] (rev c6)
```
