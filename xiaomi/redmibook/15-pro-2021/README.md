# Xiaomi Redmibook 15 Pro (2021)

## Tested Hardware

```shellsession
$ lspci -nn
00:00.0 Host bridge [0600]: Intel Corporation Tiger Lake-UP3/H35 4 cores Host Bridge/DRAM Registers [8086:9a14] (rev 01)
00:02.0 VGA compatible controller [0300]: Intel Corporation TigerLake-LP GT2 [Iris Xe Graphics] [8086:9a49] (rev 01)
00:04.0 Signal processing controller [1180]: Intel Corporation TigerLake-LP Dynamic Tuning Processor Participant [8086:9a03] (rev 01)
00:08.0 System peripheral [0880]: Intel Corporation GNA Scoring Accelerator module [8086:9a11] (rev 01)
00:0a.0 Signal processing controller [1180]: Intel Corporation Tigerlake Telemetry Aggregator Driver [8086:9a0d] (rev 01)
00:0d.0 USB controller [0c03]: Intel Corporation Tiger Lake-LP Thunderbolt 4 USB Controller [8086:9a13] (rev 01)
00:14.0 USB controller [0c03]: Intel Corporation Tiger Lake-LP USB 3.2 Gen 2x1 xHCI Host Controller [8086:a0ed] (rev 20)
00:14.2 RAM memory [0500]: Intel Corporation Tiger Lake-LP Shared SRAM [8086:a0ef] (rev 20)
00:14.3 Network controller [0280]: Intel Corporation Wi-Fi 6 AX201 [8086:a0f0] (rev 20)
00:15.0 Serial bus controller [0c80]: Intel Corporation Tiger Lake-LP Serial IO I2C Controller #0 [8086:a0e8] (rev 20)
00:15.1 Serial bus controller [0c80]: Intel Corporation Tiger Lake-LP Serial IO I2C Controller #1 [8086:a0e9] (rev 20)
00:15.2 Serial bus controller [0c80]: Intel Corporation Tiger Lake-LP Serial IO I2C Controller #2 [8086:a0ea] (rev 20)
00:15.3 Serial bus controller [0c80]: Intel Corporation Tiger Lake-LP Serial IO I2C Controller #3 [8086:a0eb] (rev 20)
00:16.0 Communication controller [0780]: Intel Corporation Tiger Lake-LP Management Engine Interface [8086:a0e0] (rev 20)
00:19.0 Serial bus controller [0c80]: Intel Corporation Tiger Lake-LP Serial IO I2C Controller #4 [8086:a0c5] (rev 20)
00:19.1 Serial bus controller [0c80]: Intel Corporation Tiger Lake-LP Serial IO I2C Controller #5 [8086:a0c6] (rev 20)
00:1d.0 PCI bridge [0604]: Intel Corporation Tiger Lake-LP PCI Express Root Port #9 [8086:a0b0] (rev 20)
00:1d.3 PCI bridge [0604]: Intel Corporation Tiger Lake-LP PCI Express Root Port #12 [8086:a0b3] (rev 20)
00:1f.0 ISA bridge [0601]: Intel Corporation Tiger Lake-LP LPC Controller [8086:a082] (rev 20)
00:1f.3 Multimedia audio controller [0401]: Intel Corporation Tiger Lake-LP Smart Sound Technology Audio Controller [8086:a0c8] (rev 20)
00:1f.4 SMBus [0c05]: Intel Corporation Tiger Lake-LP SMBus Controller [8086:a0a3] (rev 20)
00:1f.5 Serial bus controller [0c80]: Intel Corporation Tiger Lake-LP SPI Controller [8086:a0a4] (rev 20)
01:00.0 Non-Volatile memory controller [0108]: Shenzhen Longsys Electronics Co., Ltd. FORESEE XP1000 / Lexar Professional CFexpress Type B Gold series, NM620 PCIe NVME SSD (DRAM-less) [1d97:5216] (rev 01)
02:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8111/8168/8211/8411 PCI Express Gigabit Ethernet Controller [10ec:8168] (rev 15)
```

## Extra Configuration

### Bluetooth

To enable bluetooth support, set `hardware.bluetooth.enable = true;`.
