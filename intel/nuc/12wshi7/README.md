# NUC

## Tested Hardware

``` shellsession
$ lspci -nnn
00:00.0 Host bridge [0600]: Intel Corporation Device [8086:4621] (rev 02)
00:02.0 VGA compatible controller [0300]: Intel Corporation Alder Lake-P GT2 [Iris Xe Graphics] [8086:46a6] (rev 0c)
00:06.0 PCI bridge [0604]: Intel Corporation 12th Gen Core Processor PCI Express x4 Controller #0 [8086:464d] (rev 02)
00:07.0 PCI bridge [0604]: Intel Corporation Alder Lake-P Thunderbolt 4 PCI Express Root Port #0 [8086:466e] (rev 02)
00:07.2 PCI bridge [0604]: Intel Corporation Alder Lake-P Thunderbolt 4 PCI Express Root Port #2 [8086:462f] (rev 02)
00:08.0 System peripheral [0880]: Intel Corporation 12th Gen Core Processor Gaussian & Neural Accelerator [8086:464f] (rev 02)
00:0a.0 Signal processing controller [1180]: Intel Corporation Platform Monitoring Technology [8086:467d] (rev 01)
00:0d.0 USB controller [0c03]: Intel Corporation Alder Lake-P Thunderbolt 4 USB Controller [8086:461e] (rev 02)
00:0d.2 USB controller [0c03]: Intel Corporation Alder Lake-P Thunderbolt 4 NHI #0 [8086:463e] (rev 02)
00:0d.3 USB controller [0c03]: Intel Corporation Alder Lake-P Thunderbolt 4 NHI #1 [8086:466d] (rev 02)
00:14.0 USB controller [0c03]: Intel Corporation Alder Lake PCH USB 3.2 xHCI Host Controller [8086:51ed] (rev 01)
00:14.2 RAM memory [0500]: Intel Corporation Alder Lake PCH Shared SRAM [8086:51ef] (rev 01)
00:14.3 Network controller [0280]: Intel Corporation Alder Lake-P PCH CNVi WiFi [8086:51f0] (rev 01)
00:15.0 Serial bus controller [0c80]: Intel Corporation Alder Lake PCH Serial IO I2C Controller #0 [8086:51e8] (rev 01)
00:15.1 Serial bus controller [0c80]: Intel Corporation Alder Lake PCH Serial IO I2C Controller #1 [8086:51e9] (rev 01)
00:16.0 Communication controller [0780]: Intel Corporation Alder Lake PCH HECI Controller [8086:51e0] (rev 01)
00:17.0 SATA controller [0106]: Intel Corporation Alder Lake-P SATA AHCI Controller [8086:51d3] (rev 01)
00:1d.0 PCI bridge [0604]: Intel Corporation Alder Lake PCI Express Root Port #9 [8086:51b0] (rev 01)
00:1f.0 ISA bridge [0601]: Intel Corporation Alder Lake PCH eSPI Controller [8086:5182] (rev 01)
00:1f.3 Multimedia audio controller [0401]: Intel Corporation Alder Lake PCH-P High Definition Audio Controller [8086:51c8] (rev 01)
00:1f.4 SMBus [0c05]: Intel Corporation Alder Lake PCH-P SMBus Host Controller [8086:51a3] (rev 01)
00:1f.5 Serial bus controller [0c80]: Intel Corporation Alder Lake-P PCH SPI Controller [8086:51a4] (rev 01)
01:00.0 Non-Volatile memory controller [0108]: Micron Technology Inc 2550 NVMe SSD (DRAM-less) [1344:5416] (rev 01)
72:00.0 Ethernet controller [0200]: Intel Corporation Ethernet Controller I225-V [8086:15f3] (rev 03)
```

## Before Installation

These settings are needed both for booting the final install, and
installer itself. Therefore, they must be done first.

- Disable Secure Boot (but keep UEFI Boot).

# References

- [ASUS Product page](https://www.asus.com/supportonly/nuc12wshi7/helpdesk_qvl/) (formerly on Intel's site)
- [Arch Wiki on Intel NUC](https://wiki.archlinux.org/title/Intel_NUC)
