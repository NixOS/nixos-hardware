# Lenovo Thinkpad P16s Gen 2

https://www.lenovo.com/us/en/p/laptops/thinkpad/thinkpadp/thinkpad-p16s-gen-2-16-inch-intel/len101t0065


## Tested Hardware

```shell
lspci -nn
00:00.0 Host bridge [0600]: Intel Corporation Raptor Lake-P/U 4p+8e cores Host Bridge/DRAM Controller [8086:a707]
00:02.0 VGA compatible controller [0300]: Intel Corporation Raptor Lake-P [Iris Xe Graphics] [8086:a7a0] (rev 04)
00:04.0 Signal processing controller [1180]: Intel Corporation Raptor Lake Dynamic Platform and Thermal Framework Processor Participant [8086:a71d]
00:06.0 PCI bridge [0604]: Intel Corporation Raptor Lake PCIe 4.0 Graphics Port [8086:a74d]
00:06.2 PCI bridge [0604]: Intel Corporation Device [8086:a73d]
00:07.0 PCI bridge [0604]: Intel Corporation Raptor Lake-P Thunderbolt 4 PCI Express Root Port #0 [8086:a76e]
00:07.2 PCI bridge [0604]: Intel Corporation Raptor Lake-P Thunderbolt 4 PCI Express Root Port #2 [8086:a72f]
00:0d.0 USB controller [0c03]: Intel Corporation Raptor Lake-P Thunderbolt 4 USB Controller [8086:a71e]
00:0d.2 USB controller [0c03]: Intel Corporation Raptor Lake-P Thunderbolt 4 NHI #0 [8086:a73e]
00:0d.3 USB controller [0c03]: Intel Corporation Raptor Lake-P Thunderbolt 4 NHI #1 [8086:a76d]
00:14.0 USB controller [0c03]: Intel Corporation Alder Lake PCH USB 3.2 xHCI Host Controller [8086:51ed] (rev 01)
00:14.2 RAM memory [0500]: Intel Corporation Alder Lake PCH Shared SRAM [8086:51ef] (rev 01)
00:14.3 Network controller [0280]: Intel Corporation Raptor Lake PCH CNVi WiFi [8086:51f1] (rev 01)
00:15.0 Serial bus controller [0c80]: Intel Corporation Alder Lake PCH Serial IO I2C Controller #0 [8086:51e8] (rev 01)
00:16.0 Communication controller [0780]: Intel Corporation Alder Lake PCH HECI Controller [8086:51e0] (rev 01)
00:1f.0 ISA bridge [0601]: Intel Corporation Raptor Lake LPC/eSPI Controller [8086:519d] (rev 01)
00:1f.3 Audio device [0403]: Intel Corporation Raptor Lake-P/U/H cAVS [8086:51ca] (rev 01)
00:1f.4 SMBus [0c05]: Intel Corporation Alder Lake PCH-P SMBus Host Controller [8086:51a3] (rev 01)
00:1f.5 Serial bus controller [0c80]: Intel Corporation Alder Lake-P PCH SPI Controller [8086:51a4] (rev 01)
00:1f.6 Ethernet controller [0200]: Intel Corporation Ethernet Connection (23) I219-V [8086:0dc6] (rev 01)
02:00.0 Non-Volatile memory controller [0108]: SK hynix Platinum P41/PC801 NVMe Solid State Drive [1c5c:1959]
03:00.0 3D controller [0302]: NVIDIA Corporation GA107GLM [RTX A500 Laptop GPU] [10de:25bb] (rev a1)

nix-info -m
 - system: `"x86_64-linux"`
 - host os: `Linux 6.12.10-zen1, NixOS, 24.11 (Vicuna), 24.11.20250304.6af28b8`
 - multi-user?: `yes`
 - sandbox: `yes`
 - version: `nix-env (Nix) 2.24.12`
 - nixpkgs: `/nix/store/cdjqlnn7kx4hfmxkry9yjfdvqp2pradh-source`
```
