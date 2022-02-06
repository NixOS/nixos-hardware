## Dell Inspiron 5509

### Tested Hardware
``` shellsession
$ lspci -nn
00:00.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Renoir Root Complex [1022:1630]
00:00.2 IOMMU [0806]: Advanced Micro Devices, Inc. [AMD] Renoir IOMMU [1022:1631]
00:01.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Renoir PCIe Dummy Host Bridge [1022:1632]
00:02.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Renoir PCIe Dummy Host Bridge [1022:1632]
00:02.2 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Renoir PCIe GPP Bridge [1022:1634]
00:02.4 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Renoir PCIe GPP Bridge [1022:1634]
00:08.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Renoir PCIe Dummy Host Bridge [1022:1632]
00:08.1 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Renoir Internal PCIe GPP Bridge to Bus [1022:1635]
00:08.2 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Renoir Internal PCIe GPP Bridge to Bus [1022:1635]
00:14.0 SMBus [0c05]: Advanced Micro Devices, Inc. [AMD] FCH SMBus Controller [1022:790b] (rev 51)
00:14.3 ISA bridge [0601]: Advanced Micro Devices, Inc. [AMD] FCH LPC Bridge [1022:790e] (rev 51)
00:18.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Renoir Device 24: Function 0 [1022:1448]
00:18.1 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Renoir Device 24: Function 1 [1022:1449]
00:18.2 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Renoir Device 24: Function 2 [1022:144a]
00:18.3 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Renoir Device 24: Function 3 [1022:144b]
00:18.4 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Renoir Device 24: Function 4 [1022:144c]
00:18.5 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Renoir Device 24: Function 5 [1022:144d]
00:18.6 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Renoir Device 24: Function 6 [1022:144e]
00:18.7 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Renoir Device 24: Function 7 [1022:144f]
01:00.0 Network controller [0280]: Intel Corporation Wi-Fi 6 AX200 [8086:2723] (rev 1a)
02:00.0 Non-Volatile memory controller [0108]: KIOXIA Corporation Device [1e0f:0001]
03:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Lucienne [1002:164c] (rev c1)
03:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI] Device [1002:1637]
03:00.2 Encryption controller [1080]: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 10h-1fh) Platform Security Processor [1022:15df]
03:00.3 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] Renoir USB 3.1 [1022:1639]
03:00.4 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] Renoir USB 3.1 [1022:1639]
03:00.5 Multimedia controller [0480]: Advanced Micro Devices, Inc. [AMD] Raven/Raven2/FireFlight/Renoir Audio Processor [1022:15e2] (rev 01)
03:00.6 Audio device [0403]: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 10h-1fh) HD Audio Controller [1022:15e3]
04:00.0 SATA controller [0106]: Advanced Micro Devices, Inc. [AMD] FCH SATA Controller [AHCI mode] [1022:7901] (rev 81)
04:00.1 SATA controller [0106]: Advanced Micro Devices, Inc. [AMD] FCH SATA Controller [AHCI mode] [1022:7901] (rev 81)
```

### Before Installation

These settings are needed both for booting the final install, and
installer itself. Therefore, they must be done first:

+ Disable *Secure* Boot (but keep **UEFI** Boot)
+ Disable *RAID* and use **AHCI**

### Firmware Upgrades

Note that this device is supported by [fwupd](https://fwupd.org).
To perform firmware upgrades just activate the service:

```
services.fwupd.enable = true;
```

Then use `fwupdmgr` to perform updates
