# iMac 12,2, NixOS 25.11 (February 2025)

## Audio

- [x] ok

## Bluetooth

- [x] ok

## Camera

- [x] ok

Observed issues with the GNOME tooling. `vlc` and `guvcview` woth work fine.

## Thunderbolt

- [ ] Untested

## SATA

- [x] ok

## Suspend/Resume

- [ ] Untested

## WiFi

- [x] ok

## Graphics

- [x] ok

The Radeon HD 6000 series (Northern Islands) does not support `amdgpu`.
This profile uses the `radeon` driver with DPM (Dynamic Power Management)
disabled to prevent boot hangs.

## LSPCI

```
00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor Family DRAM Controller (rev 09)
00:01.0 PCI bridge: Intel Corporation Xeon E3-1200/2nd Generation Core Processor Family PCI Express Root Port (rev 09)
00:02.0 Display controller: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller (rev 09)
00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series Chipset Family MEI Controller #1 (rev 04)
00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Universal Host Controller #5 (rev 05)
00:1a.7 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #2 (rev 05)
00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset Family High Definition Audio Controller (rev 05)
00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 1 (rev b5)
00:1c.1 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 2 (rev b5)
00:1c.2 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 3 (rev b5)
00:1c.4 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 5 (rev b5)
00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Universal Host Controller #1 (rev 05)
00:1d.7 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #1 (rev 05)
00:1f.0 ISA bridge: Intel Corporation Z68 Express Chipset LPC Controller (rev 05)
00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset Family 6 port Desktop SATA AHCI Controller (rev 05)
00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family SMBus Controller (rev 05)
01:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Whistler [Radeon HD 6730M/6770M/7690M XT]
01:00.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Turks HDMI Audio [Radeon HD 6500/6600 / 6700M Series]
02:00.0 Ethernet controller: Broadcom Inc. and subsidiaries NetXtreme BCM57765 Gigabit Ethernet PCIe (rev 10)
03:00.0 Network controller: Qualcomm Atheros AR93xx Wireless Network Adapter (rev 01)
04:00.0 FireWire (IEEE 1394): LSI Corporation FW643 [TrueFire] PCIe 1394b Controller (rev 08)
05:00.0 PCI bridge: Intel Corporation CV82524 Thunderbolt Controller [Light Ridge 4C 2010]
06:00.0 PCI bridge: Intel Corporation CV82524 Thunderbolt Controller [Light Ridge 4C 2010]
06:03.0 PCI bridge: Intel Corporation CV82524 Thunderbolt Controller [Light Ridge 4C 2010]
06:04.0 PCI bridge: Intel Corporation CV82524 Thunderbolt Controller [Light Ridge 4C 2010]
06:05.0 PCI bridge: Intel Corporation CV82524 Thunderbolt Controller [Light Ridge 4C 2010]
06:06.0 PCI bridge: Intel Corporation CV82524 Thunderbolt Controller [Light Ridge 4C 2010]
07:00.0 System peripheral: Intel Corporation CV82524 Thunderbolt Controller [Light Ridge 4C 2010]
```
