## Dell Inspiron 7559

### Tested Hardware

```shellsession
$ lspci -nn
00:00.0 Host bridge [0600]: Intel Corporation Xeon E3-1200 v5/E3-1500 v5/6th Gen Core Processor Host Bridge/DRAM Registers [8086:1910] (rev 07)
00:01.0 PCI bridge [0604]: Intel Corporation 6th-10th Gen Core Processor PCIe Controller (x16) [8086:1901] (rev 07)
00:01.1 PCI bridge [0604]: Intel Corporation Xeon E3-1200 v5/E3-1500 v5/6th Gen Core Processor PCIe Controller (x8) [8086:1905] (rev 07)
00:02.0 VGA compatible controller [0300]: Intel Corporation HD Graphics 530 [8086:191b] (rev 06)
00:04.0 Signal processing controller [1180]: Intel Corporation Xeon E3-1200 v5/E3-1500 v5/6th Gen Core Processor Thermal Subsystem [8086:1903] (rev 07)
00:14.0 USB controller [0c03]: Intel Corporation 100 Series/C230 Series Chipset Family USB 3.0 xHCI Controller [8086:a12f] (rev 31)
00:14.2 Signal processing controller [1180]: Intel Corporation 100 Series/C230 Series Chipset Family Thermal Subsystem [8086:a131] (rev 31)
00:15.0 Signal processing controller [1180]: Intel Corporation 100 Series/C230 Series Chipset Family Serial IO I2C Controller #0 [8086:a160] (rev 31)
00:16.0 Communication controller [0780]: Intel Corporation 100 Series/C230 Series Chipset Family MEI Controller #1 [8086:a13a] (rev 31)
00:17.0 SATA controller [0106]: Intel Corporation HM170/QM170 Chipset SATA Controller [AHCI Mode] [8086:a103] (rev 31)
00:1c.0 PCI bridge [0604]: Intel Corporation 100 Series/C230 Series Chipset Family PCI Express Root Port #1 [8086:a110] (rev f1)
00:1c.4 PCI bridge [0604]: Intel Corporation 100 Series/C230 Series Chipset Family PCI Express Root Port #5 [8086:a114] (rev f1)
00:1c.5 PCI bridge [0604]: Intel Corporation 100 Series/C230 Series Chipset Family PCI Express Root Port #6 [8086:a115] (rev f1)
00:1c.6 PCI bridge [0604]: Intel Corporation 100 Series/C230 Series Chipset Family PCI Express Root Port #7 [8086:a116] (rev f1)
00:1f.0 ISA bridge [0601]: Intel Corporation HM170 Chipset LPC/eSPI Controller [8086:a14e] (rev 31)
00:1f.2 Memory controller [0580]: Intel Corporation 100 Series/C230 Series Chipset Family Power Management Controller [8086:a121] (rev 31)
00:1f.3 Audio device [0403]: Intel Corporation 100 Series/C230 Series Chipset Family HD Audio Controller [8086:a170] (rev 31)
00:1f.4 SMBus [0c05]: Intel Corporation 100 Series/C230 Series Chipset Family SMBus [8086:a123] (rev 31)
02:00.0 3D controller [0302]: NVIDIA Corporation GM107M [GeForce GTX 960M] [10de:139b] (rev a2)
04:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8111/8168/8211/8411 PCI Express Gigabit Ethernet Controller [10ec:8168] (rev 10)
05:00.0 Network controller [0280]: Intel Corporation Wireless 3165 [8086:3165] (rev 79)
06:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS522A PCI Express Card Reader [10ec:522a] (rev 01)

```

### Extra Configuration

#### Bluetooth

To enable bluetooth support, set `hardware.bluetooth.enable = true;`.

#### Prime Offloading

This configuration uses Nvidia Prime offloading, which allows use of the `nvidia-offload` script for running commands on the dGPU. For example, you can instruct Steam to launch a game offloaded to the GPU by setting the launch options for that game to `nvidia-offload %command%`.

#### SSD

This laptop has an optional M.2 SSD slot, which isn't accounted for here. If you are using the SSD, you could look into implementing the options in [ssd](common/pc/ssd) manually. Some sources also say you should ensure your SATA Mode is set to AHCI in your BIOS for it to be detected, however I think this is a prerequisite to installing Linux on this laptop in the first place so you probably already have that set.

#### Subwoofer

Tested with the default PipeWire configuration on Plasma, the subwoofer appears to work depending on the device Profile in sound settings ("Analog Stereo Duplex" works best for me). I have had issues with it in the past on other distros, so if it's not working on your system you could try the solution in [this thread](https://bbs.archlinux.org/viewtopic.php?id=207222).

#### Other issues

There are plenty of documented bugs and threads around issues on Dell laptops like this. Some of them stem from using the nouveau drivers, but we're using the proprietary Nvidia drivers here. Some things to look into if you're experiencing issues:

* I/O is slow: `nouveau` could be added as a kernel blocklist item: searching this repo shows other laptops with this configuration
* Power drain while sleeping: add the following as boot.kernelParams: `"mem_sleep_default=deep"`
* Issues coming back from suspend (particularly if the previous kernelParam is applied): add the following as boot.kernelParams: `"acpi_rev_override=1"` `"acpi_osi=Linux"`
  * I also spotted [one person recommending](https://connorkuehl.github.io/dell-inspiron-7559-linux-guide/) setting just `"acpi_osi="`. This article is quite old though and I haven't tested the difference.
* Brightness function keys don't work: add the following as boot.kernelParams: `"acpi_backlight=vendor"` or `"acpi_backlight=native"`
