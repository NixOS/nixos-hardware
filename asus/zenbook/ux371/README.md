# Asus Zenbook Flip S13

This is tested on an [UX371](https://www.asus.com/laptops/for-home/zenbook/zenbook-flip-s-ux371-11th-gen-intel/).

## Tested Hardware

```bash
lspci -nn
0000:00:00.0 Host bridge [0600]: Intel Corporation 11th Gen Core Processor Host Bridge/DRAM Registers [8086:9a14] (rev 01)
0000:00:02.0 VGA compatible controller [0300]: Intel Corporation TigerLake-LP GT2 [Iris Xe Graphics] [8086:9a49] (rev 01)
0000:00:04.0 Signal processing controller [1180]: Intel Corporation TigerLake-LP Dynamic Tuning Processor Participant [8086:9a03] (rev 01)
0000:00:07.0 PCI bridge [0604]: Intel Corporation Tiger Lake-LP Thunderbolt 4 PCI Express Root Port #0 [8086:9a23] (rev 01)
0000:00:07.1 PCI bridge [0604]: Intel Corporation Tiger Lake-LP Thunderbolt 4 PCI Express Root Port #1 [8086:9a25] (rev 01)
0000:00:08.0 System peripheral [0880]: Intel Corporation GNA Scoring Accelerator module [8086:9a11] (rev 01)
0000:00:0a.0 Signal processing controller [1180]: Intel Corporation Tigerlake Telemetry Aggregator Driver [8086:9a0d] (rev 01)
0000:00:0d.0 USB controller [0c03]: Intel Corporation Tiger Lake-LP Thunderbolt 4 USB Controller [8086:9a13] (rev 01)
0000:00:0d.2 USB controller [0c03]: Intel Corporation Tiger Lake-LP Thunderbolt 4 NHI #0 [8086:9a1b] (rev 01)
0000:00:0e.0 RAID bus controller [0104]: Intel Corporation Volume Management Device NVMe RAID Controller [8086:9a0b]
0000:00:12.0 Serial controller [0700]: Intel Corporation Tiger Lake-LP Integrated Sensor Hub [8086:a0fc] (rev 20)
0000:00:14.0 USB controller [0c03]: Intel Corporation Tiger Lake-LP USB 3.2 Gen 2x1 xHCI Host Controller [8086:a0ed] (rev 20)
0000:00:14.2 RAM memory [0500]: Intel Corporation Tiger Lake-LP Shared SRAM [8086:a0ef] (rev 20)
0000:00:14.3 Network controller [0280]: Intel Corporation Wi-Fi 6 AX201 [8086:a0f0] (rev 20)
0000:00:15.0 Serial bus controller [0c80]: Intel Corporation Tiger Lake-LP Serial IO I2C Controller #0 [8086:a0e8] (rev 20)
0000:00:15.1 Serial bus controller [0c80]: Intel Corporation Tiger Lake-LP Serial IO I2C Controller #1 [8086:a0e9] (rev 20)
0000:00:16.0 Communication controller [0780]: Intel Corporation Tiger Lake-LP Management Engine Interface [8086:a0e0] (rev 20)
0000:00:1d.0 System peripheral [0880]: Intel Corporation RST VMD Managed Controller [8086:09ab]
0000:00:1f.0 ISA bridge [0601]: Intel Corporation Tiger Lake-LP LPC Controller [8086:a082] (rev 20)
0000:00:1f.3 Multimedia audio controller [0401]: Intel Corporation Tiger Lake-LP Smart Sound Technology Audio Controller [8086:a0c8] (rev 20)
0000:00:1f.4 SMBus [0c05]: Intel Corporation Tiger Lake-LP SMBus Controller [8086:a0a3] (rev 20)
0000:00:1f.5 Serial bus controller [0c80]: Intel Corporation Tiger Lake-LP SPI Controller [8086:a0a4] (rev 20)
10000:e0:1d.0 PCI bridge [0604]: Intel Corporation Tiger Lake-LP PCI Express Root Port #9 [8086:a0b0] (rev 20)
10000:e1:00.0 Non-Volatile memory controller [0108]: Sandisk Corp WD Black SN750 / PC SN730 / Red SN700 NVMe SSD [15b7:5006]
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
