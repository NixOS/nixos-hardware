# Apple MacBookPro11,4

[Product page](https://support.apple.com/en-us/111955)


## Tested Hardware
```console
foo@bar:~$ lspci -nn
00:00.0 Host bridge [0600]: Intel Corporation Crystal Well DRAM Controller [8086:0d04] (rev 08)
00:01.0 PCI bridge [0604]: Intel Corporation Crystal Well PCI Express x16 Controller [8086:0d01] (rev 08)
00:01.1 PCI bridge [0604]: Intel Corporation Crystal Well PCI Express x8 Controller [8086:0d05] (rev 08)
00:02.0 VGA compatible controller [0300]: Intel Corporation Crystal Well Integrated Graphics Controller [8086:0d26] (rev 08)
00:03.0 Audio device [0403]: Intel Corporation Crystal Well HD Audio Controller [8086:0d0c] (rev 08)
00:14.0 USB controller [0c03]: Intel Corporation 8 Series/C220 Series Chipset Family USB xHCI [8086:8c31] (rev 05)
00:16.0 Communication controller [0780]: Intel Corporation 8 Series/C220 Series Chipset Family MEI Controller #1 [8086:8c3a] (rev 04)
00:1b.0 Audio device [0403]: Intel Corporation 8 Series/C220 Series Chipset High Definition Audio Controller [8086:8c20] (rev 05)
00:1c.0 PCI bridge [0604]: Intel Corporation 8 Series/C220 Series Chipset Family PCI Express Root Port #1 [8086:8c10] (rev d5)
00:1c.2 PCI bridge [0604]: Intel Corporation 8 Series/C220 Series Chipset Family PCI Express Root Port #3 [8086:8c14] (rev d5)
00:1c.3 PCI bridge [0604]: Intel Corporation 8 Series/C220 Series Chipset Family PCI Express Root Port #4 [8086:8c16] (rev d5)
00:1f.0 ISA bridge [0601]: Intel Corporation HM87 Express LPC Controller [8086:8c4b] (rev 05)
00:1f.3 SMBus [0c05]: Intel Corporation 8 Series/C220 Series Chipset Family SMBus Controller [8086:8c22] (rev 05)
00:1f.6 Signal processing controller [1180]: Intel Corporation 8 Series Chipset Family Thermal Management Controller [8086:8c24] (rev 05)
01:00.0 SATA controller [0106]: Samsung Electronics Co Ltd S4LN058A01[SSUBX] AHCI SSD Controller (Apple slot) [144d:a801] (rev 01)
03:00.0 Network controller [0280]: Broadcom Inc. and subsidiaries BCM43602 802.11ac Wireless LAN SoC [14e4:43ba] (rev 01)
04:00.0 Multimedia controller [0480]: Broadcom Inc. and subsidiaries 720p FaceTime HD Camera [14e4:1570]
05:00.0 PCI bridge [0604]: Intel Corporation DSL5520 Thunderbolt 2 Bridge [Falcon Ridge 4C 2013] [8086:156d]
06:00.0 PCI bridge [0604]: Intel Corporation DSL5520 Thunderbolt 2 Bridge [Falcon Ridge 4C 2013] [8086:156d]
06:03.0 PCI bridge [0604]: Intel Corporation DSL5520 Thunderbolt 2 Bridge [Falcon Ridge 4C 2013] [8086:156d]
06:04.0 PCI bridge [0604]: Intel Corporation DSL5520 Thunderbolt 2 Bridge [Falcon Ridge 4C 2013] [8086:156d]
06:05.0 PCI bridge [0604]: Intel Corporation DSL5520 Thunderbolt 2 Bridge [Falcon Ridge 4C 2013] [8086:156d]
06:06.0 PCI bridge [0604]: Intel Corporation DSL5520 Thunderbolt 2 Bridge [Falcon Ridge 4C 2013] [8086:156d]
07:00.0 System peripheral [0880]: Intel Corporation DSL5520 Thunderbolt 2 NHI [Falcon Ridge 4C 2013] [8086:156c]
```

## Tested Nix Configuration
 - system: `"x86_64-linux"`
 - host os: `Linux 6.12.36, NixOS, 25.11 (Xantusia), 25.11.20250708.9807714`
 - multi-user?: `yes`
 - sandbox: `yes`
 - version: `nix-env (Nix) 2.28.4`
 - channels(root): `"nixos"`
 - nixpkgs: `/nix/store/bgl6ldj5ihbwcq8p42z3a0qzgqafgk2b-source`
