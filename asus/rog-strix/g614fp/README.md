# Asus ROG Strix G16 (2025) G614rog-strix/g614fp/

A warning - this has all come from a complete Nix newbie attemping to crib something together from the other configurations in this repo. YMMV.

That said, if anybody has this laptop and wants to communicate about it you may mail ashley.x.griffiths@gmail.com.

My laptop is labelled G614FP-S5008W. This is conjecture, but I suspect that the 6 refers the 16" screen size; 1 to might indicate a non-premium version; 4 to the generation number; F to the AMD Ryzen 9 9955HX version; and P to the RTX 5070 non-TI model. I suspect the S refers to the WQXGA screen.
 
The laptop is linked here: https://rog.asus.com/laptops/rog-strix/rog-strix-g16-2025-g614/

# Installing

## Initial install

I was unable to get the NixOS GUI installer to work because wireless could not be configured and I couldn't get the installer to put volumes on lvm on crypt, but I was able to fumble around configuring this in a terminal window and then running nixos-install per https://nixos.org/manual/nixos/stable/#sec-installation-manual

# Device Information

```bash
> sudo dmidecode -s bios-version
G614FP.307

> lspci -nn
00:00.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge Root Complex [1022:14d8]
00:00.2 IOMMU [0806]: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge IOMMU [1022:14d9]
00:01.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge Dummy Host Bridge [1022:14da]
00:01.1 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge GPP Bridge [1022:14db]
00:01.2 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge GPP Bridge [1022:14db]
00:01.6 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge GPP Bridge [1022:14db]
00:01.7 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge GPP Bridge [1022:14db]
00:02.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge Dummy Host Bridge [1022:14da]
00:02.1 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge GPP Bridge [1022:14db]
00:03.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge Dummy Host Bridge [1022:14da]
00:04.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge Dummy Host Bridge [1022:14da]
00:08.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge Dummy Host Bridge [1022:14da]
00:08.1 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge Internal GPP Bridge to Bus [C:A] [1022:14dd]
00:08.3 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge Internal GPP Bridge to Bus [C:A] [1022:14dd]
00:14.0 SMBus [0c05]: Advanced Micro Devices, Inc. [AMD] FCH SMBus Controller [1022:790b] (rev 71)
00:14.3 ISA bridge [0601]: Advanced Micro Devices, Inc. [AMD] FCH LPC Bridge [1022:790e] (rev 51)
00:18.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge Data Fabric; Function 0 [1022:14e0]
00:18.1 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge Data Fabric; Function 1 [1022:14e1]
00:18.2 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge Data Fabric; Function 2 [1022:14e2]
00:18.3 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge Data Fabric; Function 3 [1022:14e3]
00:18.4 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge Data Fabric; Function 4 [1022:14e4]
00:18.5 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge Data Fabric; Function 5 [1022:14e5]
00:18.6 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge Data Fabric; Function 6 [1022:14e6]
00:18.7 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge Data Fabric; Function 7 [1022:14e7]
01:00.0 VGA compatible controller [0300]: NVIDIA Corporation GB206M [GeForce RTX 5070 Max-Q / Mobile] [10de:2d58] (rev a1)
01:00.1 Audio device [0403]: NVIDIA Corporation GB206 High Definition Audio Controller [10de:22eb] (rev a1)
02:00.0 Non-Volatile memory controller [0108]: Micron Technology Inc 2500 NVMe SSD (DRAM-less) [1344:5425] (rev 01)
03:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8111/8168/8211/8411 PCI Express Gigabit Ethernet Controller [10ec:8168] (rev 15)
04:00.0 Network controller [0280]: MEDIATEK Corp. MT7922 802.11ax PCI Express Wireless Network Adapter [14c3:0616]
05:00.0 PCI bridge [0604]: ASMedia Technology Inc. ASM4242 PCIe Switch Upstream Port [1b21:2421] (rev 01)
06:00.0 PCI bridge [0604]: ASMedia Technology Inc. ASM4242 PCIe Switch Downstream Port [1b21:2423] (rev 01)
06:01.0 PCI bridge [0604]: ASMedia Technology Inc. ASM4242 PCIe Switch Downstream Port [1b21:2423] (rev 01)
06:02.0 PCI bridge [0604]: ASMedia Technology Inc. ASM4242 PCIe Switch Downstream Port [1b21:2423] (rev 01)
06:03.0 PCI bridge [0604]: ASMedia Technology Inc. ASM4242 PCIe Switch Downstream Port [1b21:2423] (rev 01)
67:00.0 USB controller [0c03]: ASMedia Technology Inc. ASM4242 USB 3.2 xHCI Controller [1b21:2426] (rev 01)
68:00.0 USB controller [0c03]: ASMedia Technology Inc. ASM4242 USB 4 / Thunderbolt 3 Host Router [1b21:2425] (rev 01)
69:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Granite Ridge [Radeon Graphics] [1002:13c0] (rev d8)
69:00.2 Encryption controller [1080]: Advanced Micro Devices, Inc. [AMD] Family 19h PSP/CCP [1022:1649]
69:00.3 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge USB 3.1 xHCI [1022:15b6]
69:00.4 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge USB 3.1 xHCI [1022:15b7]
69:00.5 Multimedia controller [0480]: Advanced Micro Devices, Inc. [AMD] Audio Coprocessor [1022:15e2] (rev 62)
69:00.6 Audio device [0403]: Advanced Micro Devices, Inc. [AMD] Family 17h/19h/1ah HD Audio Controller [1022:15e3]
6a:00.0 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge USB 2.0 xHCI [1022:15b8]

```

## Solved problems

### 30 second delay

With a fresh nixos install there is a long (perhaps 30 seconds) delay after selecting the OS from systemd-boot before displaying stage1.

This is apparently caused by a bios bug. Adding the `gpiolib_acpi.run_edge_events_on_boot=0` kernel parameter resolves it (taken from https://patchwork.ozlabs.org/project/linux-gpio/patch/20251217120146.51321-1-francesco.lauritano1@protonmail.com/ )

I can't say whether there are any other implications to this fix, but it doesn't appear to have degraded any other functionality.

## Unsolved Problems

### Wireless sleep issue

I have seen an issue where wireless broken after resume from sleep. Might have resolved for unknown reason. Sample:
```
Apr 12 20:02:02 nixos kernel: mt7921e 0000:04:00.0: Message 00020007 (seq 4) timeout
Apr 12 20:02:02 nixos kernel: mt7921e 0000:04:00.0: PM: dpm_run_callback(): pci_pm_restore returns -110
Apr 12 20:02:02 nixos kernel: mt7921e 0000:04:00.0: PM: failed to restore async: error -110
Apr 12 20:02:02 nixos kernel: mt7921e 0000:04:00.0: Message 00000010 (seq 5) timeout
Apr 12 20:02:02 nixos kernel: mt7921e 0000:04:00.0: Failed to get patch semaphore
Apr 12 20:02:02 nixos kernel: mt7921e 0000:04:00.0: Message 00000010 (seq 6) timeout
Apr 12 20:02:02 nixos kernel: mt7921e 0000:04:00.0: Failed to get patch semaphore
Apr 12 20:02:02 nixos kernel: mt7921e 0000:04:00.0: Message 000046ed (seq 7) timeout
```

### ACPI error at boot

I'm already on the most recent bios (307), so not sure what else I can do here. No apparent functional issue.

```
Apr 12 20:08:16 nixos kernel: ACPI BIOS Error (bug): Could not resolve symbol [\_SB.PCI0.GPP2], AE_NOT_FOUND (20240827/dswload2-162)
Apr 12 20:08:16 nixos kernel: ACPI Error: AE_NOT_FOUND, During name lookup/catalog (20240827/psobject-220)
Apr 12 20:08:16 nixos kernel: ACPI: Skipping parse of AML opcode: Scope (0x0010)
Apr 12 20:08:16 nixos kernel: ACPI BIOS Error (bug): Could not resolve symbol [\_SB.PCI0.GPP4], AE_NOT_FOUND (20240827/dswload2-162)
Apr 12 20:08:16 nixos kernel: ACPI Error: AE_NOT_FOUND, During name lookup/catalog (20240827/psobject-220)
```

### Backlight errors

Backlight control appears to work, but it shows errors. For example, at boot:
```
Apr 10 00:32:44 nixos kernel: nvidia-wmi-ec-backlight 603E9613-EF25-4338-A3D0-C46177516DB7: EC backlight control failed: AE_NOT_FOUND

> sudo systemctl status systemd-backlight@backlight\:nvidia_wmi_ec_backlight.service 

× systemd-backlight@backlight:nvidia_wmi_ec_backlight.service - Load/Save Screen Backlight Brightness of backlight:nvidia_wmi_ec_backlight
     Loaded: loaded (/etc/systemd/system/systemd-backlight@.service; static)
    Drop-In: /nix/store/skd437kc7880bpx5p7cfdk7jpsnhigwh-system-units/systemd-backlight@.service.d
             └─overrides.conf
     Active: failed (Result: exit-code) since Tue 2026-04-14 17:54:26 BST; 2h 45min ago
 Invocation: 75c5a3a7dd6b481ea08758f4938fbfa1
       Docs: man:systemd-backlight@.service(8)
    Process: 1703 ExecStart=/nix/store/y2rzx7s3kr3v95rsrl2141s8vaa4mkjf-systemd-258.5/lib/systemd/systemd-backlight load backlight:nvidia_wmi_ec_backlight (code=exited, status=1/FAILURE)
   Main PID: 1703 (code=exited, status=1/FAILURE)
         IP: 0B in, 0B out
         IO: 0B read, 0B written
   Mem peak: 2.4M
        CPU: 7ms

Apr 14 17:54:26 nixos systemd[1]: Starting Load/Save Screen Backlight Brightness of backlight:nvidia_wmi_ec_backlight...
Apr 14 17:54:26 nixos systemd-backlight[1703]: nvidia_wmi_ec_backlight: Failed to write system 'brightness' attribute: Input/output error
Apr 14 17:54:26 nixos systemd[1]: systemd-backlight@backlight:nvidia_wmi_ec_backlight.service: Main process exited, code=exited, status=1/FAILURE
Apr 14 17:54:26 nixos systemd[1]: systemd-backlight@backlight:nvidia_wmi_ec_backlight.service: Failed with result 'exit-code'.
Apr 14 17:54:26 nixos systemd[1]: Failed to start Load/Save Screen Backlight Brightness of backlight:nvidia_wmi_ec_backlight.
```

Then when trying to call `brightnessctl -d 'nvidia_wmi_ec_backlight' set 100`:

May 04 02:15:35 nixos (sd-bright)[3358]: nvidia_wmi_ec_backlight: Failed to write brightness to device: Input/output error
May 04 02:15:35 nixos kernel: ACPI BIOS Error (bug): Could not resolve symbol [\_SB.PCI0.SBRG.BPWM], AE_NOT_FOUND (20240827/psargs-332)
May 04 02:15:35 nixos kernel: ACPI Error: Aborting method \_SB.PCI0.AWMI.WMAA due to previous error (AE_NOT_FOUND) (20240827/psparse-529)
May 04 02:15:35 nixos kernel: nvidia-wmi-ec-backlight 603E9613-EF25-4338-A3D0-C46177516DB7: EC backlight control failed: AE_NOT_FOUND

It does manage to update the brightness. The various acpi_backlight kernel parameters can make the error go away, but at the cost of not actually updating the brightness! The same applies with the asus/zephyrus/shared/backlight.nix args.

### ASUS driver

Apr 10 00:32:45 nixos kernel: asus 0003:0B05:19B6.0001: input,hiddev96,hidraw0: USB HID v1.10 Keyboard [ASUSTek Computer Inc. N-KEY Device] on usb-0000:69:00.3-1/input0
Apr 10 00:32:45 nixos kernel: asus 0003:0B05:19B6.0002: hiddev97,hidraw1: USB HID v1.10 Device [ASUSTek Computer Inc. N-KEY Device] on usb-0000:69:00.3-1/input1
Apr 10 00:32:45 nixos kernel: asus 0003:0B05:19B6.0002: Asus input not registered
Apr 10 00:32:45 nixos kernel: asus 0003:0B05:19B6.0002: probe with driver asus failed with error -12

Unclear if this affects anything.

### Instant resume from suspend

Seems similar to bbs.archlinux.org/viewtopic.php?pid=2116347#p2116347 also see https://wiki.archlinux.org/title/Ryzen#Freeze_on_shutdown,_reboot_and_suspend  https://bbs.archlinux.org/viewtopic.php?id=288637
https://forum.manjaro.org/t/system-do-not-wake-up-after-suspend/76681/2

Apr 13 20:13:07 nixos kernel: amd_pmc AMDI0008:00: Last suspend didn't reach deepest state

Not seen this since, so presumably resolved by some element of the configuration applied here?

## Breadcrumbs:
  * https://rog.asus.com/laptops/rog-strix/rog-strix-g16-2025-g614/
  * https://rog.asus.com/laptops/rog-strix/rog-strix-g16-2025-g614/helpdesk_bios/


