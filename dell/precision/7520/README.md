# Dell Precision 7520

This configuration opts to use the non-free nvidia driver, as UI glitching was often observed with `nouveau` when using
a compositor.

## Device Details

- Dell Precision 7520 (07B0)
- Intel Core i7-7820HQ CPU (Kaby Lake)
- 32GB RAM
- SK hynix SC311 SATA 1TB
- Intel HD Graphics 630 (Coffee Lake)
- NVIDIA GM206GLM [Quadro M2200 Mobile]

## Tested Hardware

```bash
❯ lspci -nn
00:00.0 Host bridge [0600]: Intel Corporation Xeon E3-1200 v6/7th Gen Core Processor Host Bridge/DRAM Registers [8086:5910] (rev 05)
00:01.0 PCI bridge [0604]: Intel Corporation 6th-10th Gen Core Processor PCIe Controller (x16) [8086:1901] (rev 05)
00:02.0 VGA compatible controller [0300]: Intel Corporation HD Graphics 630 [8086:591b] (rev 04)
00:04.0 Signal processing controller [1180]: Intel Corporation Xeon E3-1200 v5/E3-1500 v5/6th Gen Core Processor Thermal Subsystem [8086:1903] (rev 05)
00:14.0 USB controller [0c03]: Intel Corporation 100 Series/C230 Series Chipset Family USB 3.0 xHCI Controller [8086:a12f] (rev 31)
00:14.2 Signal processing controller [1180]: Intel Corporation 100 Series/C230 Series Chipset Family Thermal Subsystem [8086:a131] (rev 31)
00:15.0 Signal processing controller [1180]: Intel Corporation 100 Series/C230 Series Chipset Family Serial IO I2C Controller #0 [8086:a160] (rev 31)
00:15.1 Signal processing controller [1180]: Intel Corporation 100 Series/C230 Series Chipset Family Serial IO I2C Controller #1 [8086:a161] (rev 31)
00:16.0 Communication controller [0780]: Intel Corporation 100 Series/C230 Series Chipset Family MEI Controller #1 [8086:a13a] (rev 31)
00:17.0 RAID bus controller [0104]: Intel Corporation SATA Controller [RAID mode] [8086:2822] (rev 31)
00:1c.0 PCI bridge [0604]: Intel Corporation 100 Series/C230 Series Chipset Family PCI Express Root Port #2 [8086:a111] (rev f1)
00:1c.2 PCI bridge [0604]: Intel Corporation 100 Series/C230 Series Chipset Family PCI Express Root Port #3 [8086:a112] (rev f1)
00:1c.4 PCI bridge [0604]: Intel Corporation 100 Series/C230 Series Chipset Family PCI Express Root Port #5 [8086:a114] (rev f1)
00:1f.0 ISA bridge [0601]: Intel Corporation CM238 Chipset LPC/eSPI Controller [8086:a154] (rev 31)
00:1f.2 Memory controller [0580]: Intel Corporation 100 Series/C230 Series Chipset Family Power Management Controller [8086:a121] (rev 31)
00:1f.3 Audio device [0403]: Intel Corporation CM238 HD Audio Controller [8086:a171] (rev 31)
00:1f.4 SMBus [0c05]: Intel Corporation 100 Series/C230 Series Chipset Family SMBus [8086:a123] (rev 31)
00:1f.6 Ethernet controller [0200]: Intel Corporation Ethernet Connection (5) I219-LM [8086:15e3] (rev 31)
01:00.0 VGA compatible controller [0300]: NVIDIA Corporation GM206GLM [Quadro M2200 Mobile] [10de:1436] (rev a1)
01:00.1 Audio device [0403]: NVIDIA Corporation GM206 High Definition Audio Controller [10de:0fba] (rev a1)
02:00.0 Network controller [0280]: Intel Corporation Wireless 8265 / 8275 [8086:24fd] (rev 78)
03:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS525A PCI Express Card Reader [10ec:525a] (rev 01)
04:00.0 PCI bridge [0604]: Intel Corporation JHL6340 Thunderbolt 3 Bridge (C step) [Alpine Ridge 2C 2016] [8086:15da] (rev 02)
05:00.0 PCI bridge [0604]: Intel Corporation JHL6340 Thunderbolt 3 Bridge (C step) [Alpine Ridge 2C 2016] [8086:15da] (rev 02)
05:01.0 PCI bridge [0604]: Intel Corporation JHL6340 Thunderbolt 3 Bridge (C step) [Alpine Ridge 2C 2016] [8086:15da] (rev 02)
05:02.0 PCI bridge [0604]: Intel Corporation JHL6340 Thunderbolt 3 Bridge (C step) [Alpine Ridge 2C 2016] [8086:15da] (rev 02)
3c:00.0 USB controller [0c03]: Intel Corporation JHL6340 Thunderbolt 3 USB 3.1 Controller (C step) [Alpine Ridge 2C 2016] [8086:15db] (rev 02)
```

## Doesn't work

- External monitor for luks passphrase entry

## Firmware Upgrades

Note that this device is supported by fwupd. To perform firmware upgrades just activate the service:

```nix
services.fwupd.enable = true;
```

Then use `fwupdmgr` to perform updates

## Nvidia Driver

The choice of the `legacy_390` driver is based on looking for PCI Device ID `10de:1436`. On the [nvidia driver site](https://www.nvidia.com/en-us/drivers/unix/legacy-gpu/) which should indicate the
driver, the exact device isn't listed. However, we can see
[here](https://linux-hardware.org/?id=pci:10de-1436-103c-1909) has nvidia driver "375.82 and newer" listed. Since the
newest nvidia drivers don't support legacy devices, the closest version newer than 375.82 was chosen.
