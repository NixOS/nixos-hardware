## Dell Inspiron 3442

### Tested Hardware

```shellsession
$ lspci -nn

00:00.0 Host bridge [0600]: Intel Corporation Haswell-ULT DRAM Controller [8086:0a04] (rev 0b)
00:02.0 VGA compatible controller [0300]: Intel Corporation Haswell-ULT Integrated Graphics Controller [8086:0a16] (rev 0b)
00:03.0 Audio device [0403]: Intel Corporation Haswell-ULT HD Audio Controller [8086:0a0c] (rev 0b)
00:14.0 USB controller [0c03]: Intel Corporation 8 Series USB xHCI HC [8086:9c31] (rev 04)
00:16.0 Communication controller [0780]: Intel Corporation 8 Series HECI #0 [8086:9c3a] (rev 04)
00:1b.0 Audio device [0403]: Intel Corporation 8 Series HD Audio Controller [8086:9c20] (rev 04)
00:1c.0 PCI bridge [0604]: Intel Corporation 8 Series PCI Express Root Port 1 [8086:9c10] (rev e4)
00:1c.2 PCI bridge [0604]: Intel Corporation 8 Series PCI Express Root Port 3 [8086:9c14] (rev e4)
00:1c.3 PCI bridge [0604]: Intel Corporation 8 Series PCI Express Root Port 4 [8086:9c16] (rev e4)
00:1d.0 USB controller [0c03]: Intel Corporation 8 Series USB EHCI #1 [8086:9c26] (rev 04)
00:1f.0 ISA bridge [0601]: Intel Corporation 8 Series LPC Controller [8086:9c45] (rev 04)
00:1f.2 SATA controller [0106]: Intel Corporation 8 Series SATA Controller 1 [AHCI mode] [8086:9c03] (rev 04)
00:1f.3 SMBus [0c05]: Intel Corporation 8 Series SMBus Controller [8086:9c22] (rev 04)
06:00.0 Network controller [0280]: Broadcom Inc. and subsidiaries BCM43142 802.11b/g/n [14e4:4365] (rev 01)
07:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL810xE PCI Express Fast Ethernet controller [10ec:8136] (rev 07)

```

### Extra Configuration

#### Bluetooth

To enable bluetooth support, set `hardware.bluetooth.enable = true;`.

### Firmware Upgrades

This device is partially supported by [fwupd](https://fwupd.org).
Use `fwupdmgr` to perform updates.
