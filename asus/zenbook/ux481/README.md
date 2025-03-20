# Asus Zenbook Duo 14 UX481

These profiles has been tested on a slightly modified device as I have swapped the Intel Optane NVME for a Kingston NVME with a higher capacity.

# GPU

You need to pick between running only Intel iGPU or running both Intel iGPU and NVIDIA dGPU. By only running iGPU the battery life is a bit better as the dGPU is turned off. You can offload applications if running on NVIDIA dGPU using

```bash
nvidia-offload
```

## Battery charging limit:

Using the ASUS module you can limit the charging percentage. This can be done as follows:

```nix
hardware.asus.battery =
{
  chargeUpto = 90;   # Maximum level of charge for your battery, as a percentage.
  enableChargeUptoScript = true; # Whether to add charge-upto to environment.systemPackages. `charge-upto 100` temporarily sets the charge limit to 100%, useful if you're going to need the extra battery on a longer journey.
};
```

## Hardware:

```bash
$ lspci -nn
00:00.0 Host bridge [0600]: Intel Corporation Comet Lake-U v1 4c Host Bridge/DRAM Controller [8086:9b61] (rev 0c)
00:02.0 VGA compatible controller [0300]: Intel Corporation CometLake-U GT2 [UHD Graphics] [8086:9b41] (rev 02)
00:04.0 Signal processing controller [1180]: Intel Corporation Xeon E3-1200 v5/E3-1500 v5/6th Gen Core Processor Thermal Subsystem [8086:1903] (rev 0c)
00:08.0 System peripheral [0880]: Intel Corporation Xeon E3-1200 v5/v6 / E3-1500 v5 / 6th/7th/8th Gen Core Processor Gaussian Mixture Model [8086:1911]
00:12.0 Signal processing controller [1180]: Intel Corporation Comet Lake Thermal Subsytem [8086:02f9]
00:14.0 USB controller [0c03]: Intel Corporation Comet Lake PCH-LP USB 3.1 xHCI Host Controller [8086:02ed]
00:14.2 RAM memory [0500]: Intel Corporation Comet Lake PCH-LP Shared SRAM [8086:02ef]
00:14.3 Network controller [0280]: Intel Corporation Comet Lake PCH-LP CNVi WiFi [8086:02f0]
00:15.0 Serial bus controller [0c80]: Intel Corporation Serial IO I2C Host Controller [8086:02e8]
00:15.1 Serial bus controller [0c80]: Intel Corporation Comet Lake Serial IO I2C Host Controller [8086:02e9]
00:15.2 Serial bus controller [0c80]: Intel Corporation Comet Lake PCH-LP LPSS: I2C Controller #2 [8086:02ea]
00:15.3 Serial bus controller [0c80]: Intel Corporation Device [8086:02eb]
00:16.0 Communication controller [0780]: Intel Corporation Comet Lake Management Engine Interface [8086:02e0]
00:1c.0 PCI bridge [0604]: Intel Corporation Comet Lake PCI Express Root Port #1 [8086:02b8] (rev f0)
00:1c.4 PCI bridge [0604]: Intel Corporation Comet Lake PCI Express Root Port #5 [8086:02bc] (rev f0)
00:1d.0 PCI bridge [0604]: Intel Corporation Comet Lake PCI Express Root Port #9 [8086:02b0] (rev f0)
00:1d.4 PCI bridge [0604]: Intel Corporation Comet Lake PCI Express Root Port #13 [8086:02b4] (rev f0)
00:1f.0 ISA bridge [0601]: Intel Corporation Comet Lake PCH-LP LPC Premium Controller/eSPI Controller [8086:0284]
00:1f.3 Audio device [0403]: Intel Corporation Comet Lake PCH-LP cAVS [8086:02c8]
00:1f.4 SMBus [0c05]: Intel Corporation Comet Lake PCH-LP SMBus Host Controller [8086:02a3]
00:1f.5 Serial bus controller [0c80]: Intel Corporation Comet Lake SPI (flash) Controller [8086:02a4]
02:00.0 3D controller [0302]: NVIDIA Corporation GP108BM [GeForce MX250] [10de:1d52] (rev a1)
03:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS522A PCI Express Card Reader [10ec:522a] (rev 01)
04:00.0 Non-Volatile memory controller [0108]: Kingston Technology Company, Inc. NV2 NVMe SSD [TC2200] (DRAM-less) [2646:501d]
```
