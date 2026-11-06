# HP Omen 15-ek1013dx

## ACPI platform profiles
This config enables `hp-wmi`, which allows switch between cool, balanced, and performance modes on the platform EC, used by power management tools like `power-profile-daemon` and `tlp`.

# [Product support](https://support.hp.com/us-en/product/details/omen-15.6-inch-gaming-laptop-pc-15-ek1000/model/2100045567?sku=350D5UA) 


```bash
$ lspci -nn
00:00.0 Host bridge [0600]: Intel Corporation 10th Gen Core Processor Host Bridge/DRAM Registers [8086:9b54] (rev 02)
00:01.0 PCI bridge [0604]: Intel Corporation 6th-10th Gen Core Processor PCIe Controller (x16) [8086:1901] (rev 02)
00:02.0 VGA compatible controller [0300]: Intel Corporation CometLake-H GT2 [UHD Graphics] [8086:9bc4] (rev 05)
00:12.0 Signal processing controller [1180]: Intel Corporation Comet Lake PCH Thermal Controller [8086:06f9]
00:14.0 USB controller [0c03]: Intel Corporation Comet Lake USB 3.1 xHCI Host Controller [8086:06ed]
00:14.2 RAM memory [0500]: Intel Corporation Comet Lake PCH Shared SRAM [8086:06ef]
00:14.3 Network controller [0280]: Intel Corporation Comet Lake PCH CNVi WiFi [8086:06f0]
00:15.0 Serial bus controller [0c80]: Intel Corporation Comet Lake PCH Serial IO I2C Controller #0 [8086:06e8]
00:15.1 Serial bus controller [0c80]: Intel Corporation Comet Lake PCH Serial IO I2C Controller #1 [8086:06e9]
00:16.0 Communication controller [0780]: Intel Corporation Comet Lake HECI Controller [8086:06e0]
00:17.0 RAID bus controller [0104]: Intel Corporation 82801 Mobile SATA Controller [RAID mode] [8086:282a]
00:1b.0 PCI bridge [0604]: Intel Corporation Comet Lake PCI Express Root Port #17 [8086:06c0] (rev f0)
00:1b.4 PCI bridge [0604]: Intel Corporation Comet Lake PCI Express Root Port #21 [8086:06ac] (rev f0)
00:1d.0 PCI bridge [0604]: Intel Corporation Device [8086:06b5] (rev f0)
00:1d.7 PCI bridge [0604]: Intel Corporation Device [8086:06b7] (rev f0)
00:1f.0 ISA bridge [0601]: Intel Corporation Comet Lake LPC Controller [8086:068d]
00:1f.3 Multimedia audio controller [0401]: Intel Corporation Comet Lake PCH cAVS [8086:06c8]
00:1f.4 SMBus [0c05]: Intel Corporation Comet Lake PCH SMBus Controller [8086:06a3]
00:1f.5 Serial bus controller [0c80]: Intel Corporation Comet Lake PCH SPI Controller [8086:06a4]
01:00.0 VGA compatible controller [0300]: NVIDIA Corporation GA104M [GeForce RTX 3070 Mobile / Max-Q] [10de:24dd] (rev a1)
01:00.1 Audio device [0403]: NVIDIA Corporation GA104 High Definition Audio Controller [10de:228b] (rev a1)
02:00.0 PCI bridge [0604]: Intel Corporation JHL7540 Thunderbolt 3 Bridge [Titan Ridge 2C 2018] [8086:15e7] (rev 06)
03:00.0 PCI bridge [0604]: Intel Corporation JHL7540 Thunderbolt 3 Bridge [Titan Ridge 2C 2018] [8086:15e7] (rev 06)
03:01.0 PCI bridge [0604]: Intel Corporation JHL7540 Thunderbolt 3 Bridge [Titan Ridge 2C 2018] [8086:15e7] (rev 06)
03:02.0 PCI bridge [0604]: Intel Corporation JHL7540 Thunderbolt 3 Bridge [Titan Ridge 2C 2018] [8086:15e7] (rev 06)
04:00.0 System peripheral [0880]: Intel Corporation JHL7540 Thunderbolt 3 NHI [Titan Ridge 2C 2018] [8086:15e8] (rev 06)
3a:00.0 USB controller [0c03]: Intel Corporation JHL7540 Thunderbolt 3 USB Controller [Titan Ridge 2C 2018] [8086:15e9] (rev 06)
3b:00.0 Non-Volatile memory controller [0108]: Toshiba Corporation XG6 NVMe SSD Controller [1179:011a]
3c:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8111/8168/8211/8411 PCI Express Gigabit Ethernet Controller [10ec:8168] (rev 16)
3d:00.0 SD Host controller [0805]: Genesys Logic, Inc GL9750 SD Host Controller [17a0:9750] (rev 01)
 ```
