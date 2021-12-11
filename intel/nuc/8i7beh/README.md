# NUC

## Tested Hardware

``` shellsession
$ lspci -nnn
00:00.0 Host bridge [0600]: Intel Corporation 8th Gen Core Processor Host Bridge/DRAM Registers [8086:3ed0] (rev 08)
00:02.0 VGA compatible controller [0300]: Intel Corporation CoffeeLake-U GT3e [Iris Plus Graphics 655] [8086:3ea5] (rev 01)
00:08.0 System peripheral [0880]: Intel Corporation Xeon E3-1200 v5/v6 / E3-1500 v5 / 6th/7th/8th Gen Core Processor Gaussian Mixture Model [8086:1911]
00:12.0 Signal processing controller [1180]: Intel Corporation Cannon Point-LP Thermal Controller [8086:9df9] (rev 30)
00:14.0 USB controller [0c03]: Intel Corporation Cannon Point-LP USB 3.1 xHCI Controller [8086:9ded] (rev 30)
00:14.2 RAM memory [0500]: Intel Corporation Cannon Point-LP Shared SRAM [8086:9def] (rev 30)
00:14.3 Network controller [0280]: Intel Corporation Cannon Point-LP CNVi [Wireless-AC] [8086:9df0] (rev 30)
00:16.0 Communication controller [0780]: Intel Corporation Cannon Point-LP MEI Controller #1 [8086:9de0] (rev 30)
00:17.0 SATA controller [0106]: Intel Corporation Cannon Point-LP SATA Controller [AHCI Mode] [8086:9dd3] (rev 30)
00:1c.0 PCI bridge [0604]: Intel Corporation Cannon Point-LP PCI Express Root Port #1 [8086:9db8] (rev f0)
00:1c.4 PCI bridge [0604]: Intel Corporation Cannon Point-LP PCI Express Root Port #5 [8086:9dbc] (rev f0)
00:1d.0 PCI bridge [0604]: Intel Corporation Cannon Point-LP PCI Express Root Port #9 [8086:9db0] (rev f0)
00:1d.6 PCI bridge [0604]: Intel Corporation Cannon Point-LP PCI Express Root Port #15 [8086:9db6] (rev f0)
00:1f.0 ISA bridge [0601]: Intel Corporation Cannon Point-LP LPC Controller [8086:9d84] (rev 30)
00:1f.3 Audio device [0403]: Intel Corporation Cannon Point-LP High Definition Audio Controller [8086:9dc8] (rev 30)
00:1f.4 SMBus [0c05]: Intel Corporation Cannon Point-LP SMBus Controller [8086:9da3] (rev 30)
00:1f.5 Serial bus controller [0c80]: Intel Corporation Cannon Point-LP SPI Controller [8086:9da4] (rev 30)
00:1f.6 Ethernet controller [0200]: Intel Corporation Ethernet Connection (6) I219-V [8086:15be] (rev 30)
3b:00.0 Non-Volatile memory controller [0108]: Samsung Electronics Co Ltd NVMe SSD Controller SM981/PM981/PM983 [144d:a808]
3c:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS522A PCI Express Card Reader [10ec:522a] (rev 01)
```

## Before Installation

These settings are needed both for booting the final install, and
installer itself. Therefore, they must be done first.

- Disable Secure Boot (but keep UEFI Boot).

# References

- [Intel Product page](https://ark.intel.com/content/www/us/en/ark/products/126140/intel-nuc-kit-nuc8i7beh.html)
- [Arch Wiki on Intel NUC](https://wiki.archlinux.org/title/Intel_NUC)
