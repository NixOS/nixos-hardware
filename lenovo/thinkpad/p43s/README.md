# Lenovo Thinkpad P43s

[Product page](https://www.lenovo.com/us/en/p/laptops/thinkpad/thinkpadp/p43s/22ws2wpp43s)

## Tested Hardware
```console
foo@bar:~$ lspci -nn
00:00.0 Host bridge [0600]: Intel Corporation Coffee Lake HOST and DRAM Controller [8086:3e34] (rev 0c)
00:02.0 VGA compatible controller [0300]: Intel Corporation WhiskeyLake-U GT2 [UHD Graphics 620] [8086:3ea0] (rev 02)
00:04.0 Signal processing controller [1180]: Intel Corporation Xeon E3-1200 v5/E3-1500 v5/6th Gen Core Processor Thermal Subsystem [8086:1903] (rev 0c)
00:08.0 System peripheral [0880]: Intel Corporation Xeon E3-1200 v5/v6 / E3-1500 v5 / 6th/7th/8th Gen Core Processor Gaussian Mixture Model [8086:1911]
00:12.0 Signal processing controller [1180]: Intel Corporation Cannon Point-LP Thermal Controller [8086:9df9] (rev 30)
00:14.0 USB controller [0c03]: Intel Corporation Cannon Point-LP USB 3.1 xHCI Controller [8086:9ded] (rev 30)
00:14.2 RAM memory [0500]: Intel Corporation Cannon Point-LP Shared SRAM [8086:9def] (rev 30)
00:14.3 Network controller [0280]: Intel Corporation Cannon Point-LP CNVi [Wireless-AC] [8086:9df0] (rev 30)
00:15.0 Serial bus controller [0c80]: Intel Corporation Cannon Point-LP Serial IO I2C Controller #0 [8086:9de8] (rev 30)
00:16.0 Communication controller [0780]: Intel Corporation Cannon Point-LP MEI Controller #1 [8086:9de0] (rev 30)
00:16.3 Serial controller [0700]: Intel Corporation Cannon Point-LP Keyboard and Text (KT) Redirection [8086:9de3] (rev 30)
00:1c.0 PCI bridge [0604]: Intel Corporation Cannon Point-LP PCI Express Root Port #1 [8086:9db8] (rev f0)
00:1c.4 PCI bridge [0604]: Intel Corporation Cannon Point-LP PCI Express Root Port #5 [8086:9dbc] (rev f0)
00:1d.0 PCI bridge [0604]: Intel Corporation Cannon Point-LP PCI Express Root Port #9 [8086:9db0] (rev f0)
00:1d.4 PCI bridge [0604]: Intel Corporation Cannon Point-LP PCI Express Root Port #13 [8086:9db4] (rev f0)
00:1f.0 ISA bridge [0601]: Intel Corporation Cannon Point-LP LPC Controller [8086:9d84] (rev 30)
00:1f.3 Audio device [0403]: Intel Corporation Cannon Point-LP High Definition Audio Controller [8086:9dc8] (rev 30)
00:1f.4 SMBus [0c05]: Intel Corporation Cannon Point-LP SMBus Controller [8086:9da3] (rev 30)
00:1f.5 Serial bus controller [0c80]: Intel Corporation Cannon Point-LP SPI Controller [8086:9da4] (rev 30)
00:1f.6 Ethernet controller [0200]: Intel Corporation Ethernet Connection (6) I219-LM [8086:15bd] (rev 30)
01:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS522A PCI Express Card Reader [10ec:522a] (rev 01)
02:00.0 PCI bridge [0604]: Intel Corporation JHL6240 Thunderbolt 3 Bridge (Low Power) [Alpine Ridge LP 2016] [8086:15c0] (rev 01)
03:00.0 PCI bridge [0604]: Intel Corporation JHL6240 Thunderbolt 3 Bridge (Low Power) [Alpine Ridge LP 2016] [8086:15c0] (rev 01)
03:01.0 PCI bridge [0604]: Intel Corporation JHL6240 Thunderbolt 3 Bridge (Low Power) [Alpine Ridge LP 2016] [8086:15c0] (rev 01)
03:02.0 PCI bridge [0604]: Intel Corporation JHL6240 Thunderbolt 3 Bridge (Low Power) [Alpine Ridge LP 2016] [8086:15c0] (rev 01)
04:00.0 System peripheral [0880]: Intel Corporation JHL6240 Thunderbolt 3 NHI (Low Power) [Alpine Ridge LP 2016] [8086:15bf] (rev 01)
3a:00.0 USB controller [0c03]: Intel Corporation JHL6240 Thunderbolt 3 USB 3.1 Controller (Low Power) [Alpine Ridge LP 2016] [8086:15c1] (rev 01)
3c:00.0 3D controller [0302]: NVIDIA Corporation GP108GLM [Quadro P520] [10de:1d34] (rev a1)
3d:00.0 Non-Volatile memory controller [0108]: SK hynix PC601 NVMe Solid State Drive [1c5c:1627]
```

## Tested Nix Configuration
 - system: `"x86_64-linux"`
 - host os: `Linux 6.12.18, NixOS, 25.05 (Warbler), 25.05.20250309.e3e32b6`
 - multi-user?: `yes`
 - sandbox: `yes`
 - version: `nix-env (Nix) 2.24.12`
 - nixpkgs: `/nix/store/g4ppspdl4fy7hnp4jgjl4ll03v7i08w3-source`
