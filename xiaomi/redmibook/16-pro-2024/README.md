# Xiaomi Redmibook 16 Pro (2024)

Note that the boot fix requires building the kernel. As such, you might run out
of space during nixos-rebuild if you mount tmpfs on `/tmp`.

## Tested Hardware

```shellsession
$ lspci -nn
00:00.0 Host bridge [0600]: Intel Corporation Device [8086:7d14] (rev 04)
00:01.0 PCI bridge [0604]: Intel Corporation Device [8086:7ecc] (rev 10)
00:02.0 VGA compatible controller [0300]: Intel Corporation Meteor Lake-P [Intel Arc Graphics] [8086:7d55] (rev 08)
00:04.0 Signal processing controller [1180]: Intel Corporation Meteor Lake-P Dynamic Tuning Technology [8086:7d03] (rev 04)
00:06.0 PCI bridge [0604]: Intel Corporation Device [8086:7e4d] (rev 20)
00:07.0 PCI bridge [0604]: Intel Corporation Meteor Lake-P Thunderbolt 4 PCI Express Root Port #1 [8086:7ec5] (rev 10)
00:08.0 System peripheral [0880]: Intel Corporation Meteor Lake-P Gaussian & Neural-Network Accelerator [8086:7e4c] (rev 20)
00:0a.0 Signal processing controller [1180]: Intel Corporation Meteor Lake-P Platform Monitoring Technology [8086:7d0d] (rev 01)
00:0b.0 Processing accelerators [1200]: Intel Corporation Meteor Lake NPU [8086:7d1d] (rev 04)
00:0d.0 USB controller [0c03]: Intel Corporation Meteor Lake-P Thunderbolt 4 USB Controller [8086:7ec0] (rev 10)
00:0d.2 USB controller [0c03]: Intel Corporation Meteor Lake-P Thunderbolt 4 NHI #0 [8086:7ec2] (rev 10)
00:12.0 Serial controller [0700]: Intel Corporation Meteor Lake-P Integrated Sensor Hub [8086:7e45] (rev 20)
00:14.0 USB controller [0c03]: Intel Corporation Meteor Lake-P USB 3.2 Gen 2x1 xHCI Host Controller [8086:7e7d] (rev 20)
00:14.2 RAM memory [0500]: Intel Corporation Device [8086:7e7f] (rev 20)
00:14.3 Network controller [0280]: Intel Corporation Meteor Lake PCH CNVi WiFi [8086:7e40] (rev 20)
00:15.0 Serial bus controller [0c80]: Intel Corporation Meteor Lake-P Serial IO I2C Controller #0 [8086:7e78] (rev 20)
00:16.0 Communication controller [0780]: Intel Corporation Meteor Lake-P CSME HECI #1 [8086:7e70] (rev 20)
00:1f.0 ISA bridge [0601]: Intel Corporation Device [8086:7e02] (rev 20)
00:1f.3 Multimedia audio controller [0401]: Intel Corporation Meteor Lake-P HD Audio Controller [8086:7e28] (rev 20)
00:1f.4 SMBus [0c05]: Intel Corporation Meteor Lake-P SMBus Controller [8086:7e22] (rev 20)
00:1f.5 Serial bus controller [0c80]: Intel Corporation Meteor Lake-P SPI Controller [8086:7e23] (rev 20)
01:00.0 Non-Volatile memory controller [0108]: SK hynix BC511 NVMe SSD [1c5c:1339]
02:00.0 Non-Volatile memory controller [0108]: Yangtze Memory Technologies Co.,Ltd PC300 NVMe SSD (DRAM-less) [1e49:1033] (rev 03)
```

## Extra Configuration

### Bluetooth

To enable bluetooth support, set `hardware.bluetooth.enable = true;`.
