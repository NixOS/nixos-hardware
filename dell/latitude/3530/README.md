# Dell Latitude 3530

Laptop was release in 2022, Has official Ubuntu Certification: https://ubuntu.com/certified/202205-30271
Every hardware in this laptop works with/is supported by upstream Linux Kernel 6.18 LTS as of 23-10-2026
The UEFI firmware of this laptop has an issue where it will cause random system hangs if Hyperthreading is turned off, behavior observed under both Windows and various Linux distros.

`lspci` output and product name confirmation :

```bash
❯ cat /sys/class/dmi/id/product_name
Latitude 3530

❯ lspci -nnk
00:00.0 Host bridge [0600]: Intel Corporation Device [8086:4609] (rev 04)
	Subsystem: Dell Device [1028:0bc3]
00:02.0 VGA compatible controller [0300]: Intel Corporation Alder Lake-UP3 GT1 [UHD Graphics] [8086:46b3] (rev 0c)
	Subsystem: Dell Device [1028:0bc3]
	Kernel driver in use: i915
	Kernel modules: i915, xe
00:04.0 Signal processing controller [1180]: Intel Corporation Alder Lake Innovation Platform Framework Processor Participant [8086:461d] (rev 04)
	Subsystem: Dell Device [1028:0bc3]
	Kernel driver in use: proc_thermal_pci
	Kernel modules: processor_thermal_device_pci
00:06.0 PCI bridge [0604]: Intel Corporation 12th Gen Core Processor PCI Express x4 Controller #0 [8086:464d] (rev 04)
	Subsystem: Dell Device [1028:0bc3]
	Kernel driver in use: pcieport
00:07.0 PCI bridge [0604]: Intel Corporation Alder Lake-P Thunderbolt 4 PCI Express Root Port #0 [8086:466e] (rev 04)
	Subsystem: Dell Device [1028:0bc3]
	Kernel driver in use: pcieport
00:08.0 System peripheral [0880]: Intel Corporation 12th Gen Core Processor Gaussian & Neural Accelerator [8086:464f] (rev 04)
	Subsystem: Dell Device [1028:0bc3]
00:0d.0 USB controller [0c03]: Intel Corporation Alder Lake-P Thunderbolt 4 USB Controller [8086:461e] (rev 04)
	Subsystem: Dell Device [1028:0bc3]
	Kernel driver in use: xhci_hcd
	Kernel modules: xhci_pci
00:0d.2 USB controller [0c03]: Intel Corporation Alder Lake-P Thunderbolt 4 NHI #0 [8086:463e] (rev 04)
	Subsystem: Dell Device [1028:0bc3]
	Kernel driver in use: thunderbolt
	Kernel modules: thunderbolt
00:12.0 Serial controller [0700]: Intel Corporation Alder Lake-P Integrated Sensor Hub [8086:51fc] (rev 01)
	Subsystem: Dell Device [1028:0bc3]
	Kernel driver in use: intel_ish_ipc
	Kernel modules: 8250_pci, intel_ish_ipc
00:14.0 USB controller [0c03]: Intel Corporation Alder Lake PCH USB 3.2 xHCI Host Controller [8086:51ed] (rev 01)
	Subsystem: Dell Device [1028:0bc3]
	Kernel driver in use: xhci_hcd
	Kernel modules: xhci_pci
00:14.2 RAM memory [0500]: Intel Corporation Alder Lake PCH Shared SRAM [8086:51ef] (rev 01)
	Subsystem: Dell Device [1028:0bc3]
00:14.3 Network controller [0280]: Intel Corporation Alder Lake-P PCH CNVi WiFi [8086:51f0] (rev 01)
	Subsystem: Intel Corporation Dual Band Wi-Fi 6(802.11ax) AX201 160MHz 2x2 [Harrison Peak] [8086:4070]
	Kernel driver in use: iwlwifi
	Kernel modules: iwlwifi
00:15.0 Serial bus controller [0c80]: Intel Corporation Alder Lake PCH Serial IO I2C Controller #0 [8086:51e8] (rev 01)
	Subsystem: Dell Device [1028:0bc3]
	Kernel driver in use: intel-lpss
	Kernel modules: intel_lpss_pci
00:15.1 Serial bus controller [0c80]: Intel Corporation Alder Lake PCH Serial IO I2C Controller #1 [8086:51e9] (rev 01)
	Subsystem: Dell Device [1028:0bc3]
	Kernel driver in use: intel-lpss
	Kernel modules: intel_lpss_pci
00:16.0 Communication controller [0780]: Intel Corporation Alder Lake PCH HECI Controller [8086:51e0] (rev 01)
	Subsystem: Dell Device [1028:0bc3]
	Kernel driver in use: mei_me
	Kernel modules: mei_me
00:17.0 SATA controller [0106]: Intel Corporation Alder Lake-P SATA AHCI Controller [8086:51d3] (rev 01)
	Subsystem: Dell Device [1028:0bc3]
	Kernel driver in use: ahci
	Kernel modules: ahci
00:1d.0 PCI bridge [0604]: Intel Corporation Alder Lake PCI Express Root Port #9 [8086:51b0] (rev 01)
	Subsystem: Dell Device [1028:0bc3]
	Kernel driver in use: pcieport
00:1f.0 ISA bridge [0601]: Intel Corporation Alder Lake PCH eSPI Controller [8086:5182] (rev 01)
	Subsystem: Dell Device [1028:0bc3]
00:1f.3 Multimedia audio controller [0401]: Intel Corporation Alder Lake PCH-P High Definition Audio Controller [8086:51c8] (rev 01)
	Subsystem: Dell Device [1028:0bc3]
	Kernel driver in use: sof-audio-pci-intel-tgl
	Kernel modules: snd_soc_avs, snd_sof_pci_intel_tgl, snd_hda_intel
00:1f.4 SMBus [0c05]: Intel Corporation Alder Lake PCH-P SMBus Host Controller [8086:51a3] (rev 01)
	Subsystem: Dell Device [1028:0bc3]
	Kernel driver in use: i801_smbus
	Kernel modules: i2c_i801
00:1f.5 Serial bus controller [0c80]: Intel Corporation Alder Lake-P PCH SPI Controller [8086:51a4] (rev 01)
	Subsystem: Dell Device [1028:0bc3]
	Kernel driver in use: intel-spi
	Kernel modules: spi_intel_pci
01:00.0 Non-Volatile memory controller [0108]: SK hynix BC901 NVMe Solid State Drive (DRAM-less) [1c5c:1d59] (rev 03)
	Subsystem: SK hynix BC901 NVMe Solid State Drive (DRAM-less) [1c5c:1d59]
	Kernel driver in use: nvme
	Kernel modules: nvme
2c:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8111/8168/8211/8411 PCI Express Gigabit Ethernet Controller [10ec:8168] (rev 15)
	Subsystem: Dell Device [1028:0bc3]
	Kernel driver in use: r8169
	Kernel modules: r8169
```
