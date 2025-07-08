# Lenovo Thinkpad E15

This is tested on an [E15 Gen4](https://psref.lenovo.com/WDProduct/ThinkPad/ThinkPad_E15_Gen_4_Intel).

## Tested Hardware

```bash
lspci -nn
00:00.0 Host bridge [0600]: Intel Corporation Alder Lake-U15 Host and DRAM Controller [8086:4601] (rev 04)
00:02.0 VGA compatible controller [0300]: Intel Corporation Alder Lake-UP3 GT2 [Iris Xe Graphics] [8086:46a8] (rev 0c)
00:04.0 Signal processing controller [1180]: Intel Corporation Alder Lake Innovation Platform Framework Processor Participant [8086:461d] (rev 04)
00:06.0 PCI bridge [0604]: Intel Corporation 12th Gen Core Processor PCI Express x4 Controller #0 [8086:464d] (rev 04)
00:07.0 PCI bridge [0604]: Intel Corporation Alder Lake-P Thunderbolt 4 PCI Express Root Port #0 [8086:466e] (rev 04)
00:08.0 System peripheral [0880]: Intel Corporation 12th Gen Core Processor Gaussian & Neural Accelerator [8086:464f] (rev 04)
00:0a.0 Signal processing controller [1180]: Intel Corporation Platform Monitoring Technology [8086:467d] (rev 01)
00:0d.0 USB controller [0c03]: Intel Corporation Alder Lake-P Thunderbolt 4 USB Controller [8086:461e] (rev 04)
00:0d.2 USB controller [0c03]: Intel Corporation Alder Lake-P Thunderbolt 4 NHI #0 [8086:463e] (rev 04)
00:0d.3 USB controller [0c03]: Intel Corporation Alder Lake-P Thunderbolt 4 NHI #1 [8086:466d] (rev 04)
00:14.0 USB controller [0c03]: Intel Corporation Alder Lake PCH USB 3.2 xHCI Host Controller [8086:51ed] (rev 01)
00:14.2 RAM memory [0500]: Intel Corporation Alder Lake PCH Shared SRAM [8086:51ef] (rev 01)
00:14.3 Network controller [0280]: Intel Corporation Alder Lake-P PCH CNVi WiFi [8086:51f0] (rev 01)
00:15.0 Serial bus controller [0c80]: Intel Corporation Alder Lake PCH Serial IO I2C Controller #0 [8086:51e8] (rev 01)
00:15.2 Serial bus controller [0c80]: Intel Corporation Alder Lake PCH Serial IO I2C Controller #2 [8086:51ea] (rev 01)
00:16.0 Communication controller [0780]: Intel Corporation Alder Lake PCH HECI Controller [8086:51e0] (rev 01)
00:1f.0 ISA bridge [0601]: Intel Corporation Alder Lake PCH eSPI Controller [8086:5182] (rev 01)
00:1f.3 Multimedia audio controller [0401]: Intel Corporation Alder Lake PCH-P High Definition Audio Controller [8086:51c8] (rev 01)
00:1f.4 SMBus [0c05]: Intel Corporation Alder Lake PCH-P SMBus Host Controller [8086:51a3] (rev 01)
00:1f.5 Serial bus controller [0c80]: Intel Corporation Alder Lake-P PCH SPI Controller [8086:51a4] (rev 01)
00:1f.6 Ethernet controller [0200]: Intel Corporation Ethernet Connection (16) I219-V [8086:1a1f] (rev 01)
01:00.0 Non-Volatile memory controller [0108]: Sandisk Corp WD PC SN740 NVMe SSD 512GB (DRAM-less) [15b7:5016] (rev 01)
```

## Updating Firmware

First enable `fwupd` in your config

```nix
services.fwupd.enable = true;
```

Then run

```bash
 $ fwupdmgr update
```
