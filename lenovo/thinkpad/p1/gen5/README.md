# Lenovo ThinkPad P1 Gen 5

https://www.lenovo.com/us/en/p/laptops/thinkpad/thinkpadp/thinkpad-p1-gen-5-16-inch-intel/len101t0033

Tested on a P1 Gen 5 with Intel Iris Xe (Alder Lake) graphics and an
NVIDIA GeForce RTX 3080 Ti Mobile (Ampere) discrete GPU.

- `lenovo-thinkpad-p1-gen5` — Alder Lake base; use on iGPU-only units.
- `lenovo-thinkpad-p1-gen5-nvidia` — adds NVIDIA PRIME **offload**. Run a
  program on the discrete GPU with `nvidia-offload <command>`.

## Tested Hardware

```shell
lspci -nn
00:00.0 Host bridge [0600]: Intel Corporation 12th Gen Core Processor Host Bridge/DRAM Registers [8086:4641] (rev 02)
00:01.0 PCI bridge [0604]: Intel Corporation 12th Gen Core Processor PCI Express x16 Controller #1 [8086:460d] (rev 02)
00:02.0 VGA compatible controller [0300]: Intel Corporation Alder Lake-P GT2 [Iris Xe Graphics] [8086:46a6] (rev 0c)
00:04.0 Signal processing controller [1180]: Intel Corporation Alder Lake Innovation Platform Framework Processor Participant [8086:461d] (rev 02)
00:06.0 PCI bridge [0604]: Intel Corporation 12th Gen Core Processor PCI Express x4 Controller #0 [8086:464d] (rev 02)
00:08.0 System peripheral [0880]: Intel Corporation 12th Gen Core Processor Gaussian & Neural Accelerator [8086:464f] (rev 02)
00:0a.0 Signal processing controller [1180]: Intel Corporation Platform Monitoring Technology [8086:467d] (rev 01)
00:14.0 USB controller [0c03]: Intel Corporation Alder Lake PCH USB 3.2 xHCI Host Controller [8086:51ed] (rev 01)
00:14.2 RAM memory [0500]: Intel Corporation Alder Lake PCH Shared SRAM [8086:51ef] (rev 01)
00:14.3 Network controller [0280]: Intel Corporation Alder Lake-P PCH CNVi WiFi [8086:51f0] (rev 01)
00:15.0 Serial bus controller [0c80]: Intel Corporation Alder Lake PCH Serial IO I2C Controller #0 [8086:51e8] (rev 01)
00:16.0 Communication controller [0780]: Intel Corporation Alder Lake PCH HECI Controller [8086:51e0] (rev 01)
00:16.3 Serial controller [0700]: Intel Corporation Alder Lake AMT SOL Redirection [8086:51e3] (rev 01)
00:1c.0 PCI bridge [0604]: Intel Corporation Device [8086:51b8] (rev 01)
00:1c.7 PCI bridge [0604]: Intel Corporation Alder Lake PCH-P PCI Express Root Port #9 [8086:51bf] (rev 01)
00:1d.0 PCI bridge [0604]: Intel Corporation Alder Lake PCI Express Root Port #9 [8086:51b0] (rev 01)
00:1f.0 ISA bridge [0601]: Intel Corporation Alder Lake PCH eSPI Controller [8086:5182] (rev 01)
00:1f.3 Multimedia audio controller [0401]: Intel Corporation Alder Lake PCH-P High Definition Audio Controller [8086:51c8] (rev 01)
00:1f.4 SMBus [0c05]: Intel Corporation Alder Lake PCH-P SMBus Host Controller [8086:51a3] (rev 01)
00:1f.5 Serial bus controller [0c80]: Intel Corporation Alder Lake-P PCH SPI Controller [8086:51a4] (rev 01)
01:00.0 VGA compatible controller [0300]: NVIDIA Corporation GA103M [GeForce RTX 3080 Ti Mobile] [10de:2420] (rev a1)
01:00.1 Audio device [0403]: NVIDIA Corporation Device [10de:2288] (rev a1)
04:00.0 Non-Volatile memory controller [0108]: SK hynix Gold P31/BC711/PC711 NVMe Solid State Drive [1c5c:174a]
0a:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS5261 PCIe SD Express Card Reader controller [10ec:5261] (rev 01)
20:00.0 PCI bridge [0604]: Intel Corporation Thunderbolt 4 Bridge [Maple Ridge 4C 2020] [8086:1136] (rev 02)
21:00.0 PCI bridge [0604]: Intel Corporation Thunderbolt 4 Bridge [Maple Ridge 4C 2020] [8086:1136] (rev 02)
21:01.0 PCI bridge [0604]: Intel Corporation Thunderbolt 4 Bridge [Maple Ridge 4C 2020] [8086:1136] (rev 02)
21:02.0 PCI bridge [0604]: Intel Corporation Thunderbolt 4 Bridge [Maple Ridge 4C 2020] [8086:1136] (rev 02)
21:03.0 PCI bridge [0604]: Intel Corporation Thunderbolt 4 Bridge [Maple Ridge 4C 2020] [8086:1136] (rev 02)
22:00.0 USB controller [0c03]: Intel Corporation Thunderbolt 4 NHI [Maple Ridge 4C 2020] [8086:1137]
56:00.0 USB controller [0c03]: Intel Corporation Thunderbolt 4 USB Controller [Maple Ridge 4C 2020] [8086:1138]

nix-info -m
 - system: `"x86_64-linux"`
 - host os: `Linux 7.0.11, NixOS, 26.05 (Yarara), 26.05.20260603.6b31628`
 - multi-user?: `yes`
 - sandbox: `yes`
 - version: `nix-env (Nix) 2.34.7`
 - nixpkgs: `/nix/store/snzg7swkp0vsd2qch9izsbmxnyb13ca0-source`
```
