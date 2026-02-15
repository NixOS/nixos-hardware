# HP Laptop 15s-fq1xxxx

## Warning

This option set may not be optimized to it's fullest. It's a carbon copy of the 14s-dq2024nf options, with Tiger Lake switched out for Ice Lake.

However, I still wanted to profit from the many optimizations provided by the library, so I'm leaving this as a starting point.

Here's the place I got the information from, they seem to be close enough to one another that not many changes are needed:

- https://browser.geekbench.com/v6/compute/4861426
- https://browser.geekbench.com/v6/cpu/15840711
- https://wiki.gentoo.org/wiki/Intel#Feature_support (for the gpu driver info. note that both Tiger and Ice Lake use the same driver)

## Device Information

Details from `tlp-stat`:

```
System         = HP  HP Laptop 15s-fq1xxx
BIOS           = F.30
EC Firmware    = 56.33
OS Release     = NixOS 25.11 (Xanthusia)
Kernel         = 6.18.5 #1-NixOS SMP PREEMPT_DYNAMIC Sun Jan 11 14:26:20 UTC 2026 x86_64
Init system    = systemd 
Boot mode      = UEFI
Suspend mode   = s2idle [deep]
```

`lspci` output:

```
00:02.0 VGA compatible controller: Intel Corporation Iris Plus Graphics G1 (Ice Lake) (rev 07)
```