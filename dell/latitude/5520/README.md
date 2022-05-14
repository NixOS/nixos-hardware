# Dell Latitude 5520

## Hardware

- 11th Gen Intel® Core™ i7-1185G7, vPro® (12 MB cache, 4 cores, 8 threads, 3.00 to 4.80 GHz Turbo)
- Intel® Iris® Xe Graphics Capable with Thunderbolt for i7-1185G7 vPro® processor
- 15.6" FHD (1920x1080) Non-Touch, Anti-Glare, 250nits
- 16 GB, 1 x 16 GB, DDR4, 3200 MHz
- 512 GB, M.2, PCIe NVMe, SSD, Class 35
- Dimensions
	- Height: 0.78 in. (19.87 mm)
	- Width: 14.09 in. (357.8 mm)
	- Depth: 9.19 in. (233.3 mm)
	- Weight: 3.50 lbs. (1.59 kg)
- Power
	- 4 Cell, 63 Wh, ExpressCharge™ Capable
	- 65W Type-C EPEAT Adapter
- Ports
	- 1 RJ-45 Ethernet port
	- 1 USB 3.2 Gen 1 port
	- 1 USB 3.2 Gen 1 port with PowerShare
	- 2 Thunderbolt 4 ports with DisplayPort Alt Mode/USB4/Power Delivery for 11th Generation Intel® Core™ i3/i5/i7 processors
	- 1 HDMI 2.0 port for 11th Generation Intel® Core™ i3/i5/i7 processors
	- 1 Universal audio port

```shellsession
↳ lspci -nn
00:00.0 Host bridge [0600]: Intel Corporation 11th Gen Core Processor Host Bridge/DRAM Registers [8086:9a14] (rev 01)
00:02.0 VGA compatible controller [0300]: Intel Corporation TigerLake-LP GT2 [Iris Xe Graphics] [8086:9a49] (rev 01)
00:04.0 Signal processing controller [1180]: Intel Corporation TigerLake-LP Dynamic Tuning Processor Participant [8086:9a03] (rev 01)
00:07.0 PCI bridge [0604]: Intel Corporation Tiger Lake-LP Thunderbolt 4 PCI Express Root Port #0 [8086:9a23] (rev 01)
00:07.1 PCI bridge [0604]: Intel Corporation Tiger Lake-LP Thunderbolt 4 PCI Express Root Port #1 [8086:9a25] (rev 01)
00:0d.0 USB controller [0c03]: Intel Corporation Tiger Lake-LP Thunderbolt 4 USB Controller [8086:9a13] (rev 01)
00:0d.2 USB controller [0c03]: Intel Corporation Tiger Lake-LP Thunderbolt 4 NHI #0 [8086:9a1b] (rev 01)
00:12.0 Serial controller [0700]: Intel Corporation Tiger Lake-LP Integrated Sensor Hub [8086:a0fc] (rev 20)
00:14.0 USB controller [0c03]: Intel Corporation Tiger Lake-LP USB 3.2 Gen 2x1 xHCI Host Controller [8086:a0ed] (rev 20)
00:14.2 RAM memory [0500]: Intel Corporation Tiger Lake-LP Shared SRAM [8086:a0ef] (rev 20)
00:14.3 Network controller [0280]: Intel Corporation Wi-Fi 6 AX201 [8086:a0f0] (rev 20)
00:15.0 Serial bus controller [0c80]: Intel Corporation Tiger Lake-LP Serial IO I2C Controller #0 [8086:a0e8] (rev 20)
00:15.1 Serial bus controller [0c80]: Intel Corporation Tiger Lake-LP Serial IO I2C Controller #1 [8086:a0e9] (rev 20)
00:16.0 Communication controller [0780]: Intel Corporation Tiger Lake-LP Management Engine Interface [8086:a0e0] (rev 20)
00:16.3 Serial controller [0700]: Intel Corporation Device [8086:a0e3] (rev 20)
00:1c.0 PCI bridge [0604]: Intel Corporation Device [8086:a0be] (rev 20)
00:1d.0 PCI bridge [0604]: Intel Corporation Tiger Lake-LP PCI Express Root Port #9 [8086:a0b0] (rev 20)
00:1f.0 ISA bridge [0601]: Intel Corporation Tiger Lake-LP LPC Controller [8086:a082] (rev 20)
00:1f.3 Audio device [0403]: Intel Corporation Tiger Lake-LP Smart Sound Technology Audio Controller [8086:a0c8] (rev 20)
00:1f.4 SMBus [0c05]: Intel Corporation Tiger Lake-LP SMBus Controller [8086:a0a3] (rev 20)
00:1f.5 Serial bus controller [0c80]: Intel Corporation Tiger Lake-LP SPI Controller [8086:a0a4] (rev 20)
00:1f.6 Ethernet controller [0200]: Intel Corporation Ethernet Connection (13) I219-LM [8086:15fb] (rev 20)
71:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS525A PCI Express Card Reader [10ec:525a] (rev 01)
72:00.0 Non-Volatile memory controller [0108]: SK hynix Device [1c5c:174a]
```

## Firmware Upgrade Manager

_Dell Latitude 5520_ seems to be supported by [fwupd](https://fwupd.org), as it is found in the [device list](https://fwupd.org/lvfs/devices/). Use `fwupdmgr` to perform updates.

## Other Stuff

Here I list a few useful things from other configs. As I don't fully understand the implications I didn't enable them.

- `services.throttled.enable`: a fix for Intel CPU throttling
- `boot.blacklistedKernelModules = [ "psmouse" ];`: "touchpad goes over i2c" (whatever that means)
- `boot.blacklistedKernelModules = [ "firewire_ohci" ];`: fix for SD card reader (from the [Arch Wiki](https://wiki.archlinux.org/title/Dell_Latitude_E5520))
- `boot.kernelParams = [ "mem_sleep_default=deep" ];`: Force S3 sleep mode to preserve battery during sleep

