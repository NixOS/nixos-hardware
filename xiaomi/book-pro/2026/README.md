# Xiaomi Book Pro (2026)

## Tested Hardware

```shellsession
$ lspci -nn
00:00.0 Host bridge [0600]: Intel Corporation Core Ultra Processors (Series 3) PTL-H12Xe [8086:b001] (rev 04)
00:02.0 VGA compatible controller [0300]: Intel Corporation Panther Lake [Arc B390] [8086:b080] (rev 04)
00:04.0 Signal processing controller [1180]: Intel Corporation Core Ultra Processors (Series 3) DTT [8086:b01d] (rev 04)
00:07.0 PCI bridge [0604]: Intel Corporation Core Ultra Processors (Series 3) USB Type-C Subsystem PCIe Root Port #23 [8086:e460] (rev 01)
00:0a.0 Signal processing controller [1180]: Intel Corporation Core Ultra Processors (Series 3) Crashlog and Telemetry [8086:b07d] (rev 04)
00:0b.0 Processing accelerators [1200]: Intel Corporation Core Ultra Processors (Series 3) NPU [8086:b03e] (rev 04)
00:0d.0 USB controller [0c03]: Intel Corporation Core Ultra Processors (Series 3) Type-C Subsystem xHCI [8086:e431] (rev 01)
00:0d.3 USB controller [0c03]: Intel Corporation Core Ultra Processors (Series 3) Thunderbolt DMA1 [8086:e434] (rev 01)
00:10.0 Digitizer Pen [0901]: Intel Corporation Core Ultra Processors (Series 3) THC #0 ID1 [8086:e448] (rev 01)
00:12.0 Serial controller [0700]: Intel Corporation Core Ultra Processors (Series 3) ISH [8086:e445] (rev 01)
00:13.0 Communication controller [0780]: Intel Corporation Core Ultra Processors (Series 3) CSME HECI #1 [8086:e462] (rev 01)
00:14.0 USB controller [0c03]: Intel Corporation Core Ultra Processors (Series 3) Standalone xHCI Controller [8086:e47d] (rev 01)
00:14.2 RAM memory [0500]: Intel Corporation Core Ultra Processors (Series 3) Shared SRAM [8086:e47f] (rev 01)
00:14.3 Network controller [0280]: Intel Corporation Core Ultra Processors (Series 3) CNVi Wi-Fi [8086:e440] (rev 01)
00:14.7 Bluetooth [0d11]: Intel Corporation Core Ultra Processors (Series 3) CNVi Bluetooth [8086:e476] (rev 01)
00:16.0 Communication controller [0780]: Intel Corporation Core Ultra Processors (Series 3) CSME HECI #1 (CSE) [8086:e470] (rev 01)
00:18.0 Communication controller [0780]: Intel Corporation Core Ultra Processors (Series 3) CSME HECI #1 [8086:e45d] (rev 01)
00:19.0 Serial bus controller [0c80]: Intel Corporation Core Ultra Processors (Series 3) I2C #4 [8086:e450] (rev 01)
00:19.1 Serial bus controller [0c80]: Intel Corporation Core Ultra Processors (Series 3) I2C #5 [8086:e451] (rev 01)
00:1c.0 PCI bridge [0604]: Intel Corporation Core Ultra Processors (Series 3) PCIe Root Port #5 [8086:e43c] (rev 01)
00:1f.0 ISA bridge [0601]: Intel Corporation Core Ultra Processors (Series 3) eSPI [8086:e402] (rev 01)
00:1f.3 Multimedia audio controller [0401]: Intel Corporation Core Ultra Processors (Series 3) HD Audio [8086:e428] (rev 01)
00:1f.4 SMBus [0c05]: Intel Corporation Core Ultra Processors (Series 3) SMBus [8086:e422] (rev 01)
00:1f.5 Serial bus controller [0c80]: Intel Corporation Core Ultra Processors (Series 3) SPI (flash) Controller [8086:e423] (rev 01)
2b:00.0 Non-Volatile memory controller [0108]: Yangtze Memory Technologies Co.,Ltd PC411 M.2 2242 NVMe SSD (DRAM-less) [1e49:1073] (rev 01)
```

## Extra Configuration

### Bluetooth

To enable bluetooth support, set `hardware.bluetooth.enable = true;`.
