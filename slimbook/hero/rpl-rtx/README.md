# [Slimbook HERO](https://slimbook.com/en/shop/product/hero-intel-i7-13620h-1115)

This configuration is for the Slimbook Hero with an i7-13620H and an RTX 4060.
Model name: SLIMBOOK HERO-RPL-RTX.

To run software on your Nvidia GPU, use the `nvidia-offload` command. For example:
```bash
nvidia-offload `nix-shell -p glxinfo --run 'glxgears'`
```
For more information, visit: https://wiki.nixos.org/wiki/NVIDIA#Offload_mode

<details><summary>System information</summary>

```bash
>neofetch
OS: NixOS 24.11.20241216.3945713 (Vicuna) x86_64 
Host: SLIMBOOK HERO-RPL-RTX 
Kernel: 6.6.66 
Uptime: 37 mins 
Packages: 1296 (nix-system), 893 (nix-user), 2 (nix-default), 9 (flatpak) 
Shell: bash 5.2.37 
Resolution: 2560x1440 
DE: GNOME 47.1 (Wayland) 
WM: Mutter 
WM Theme: Adwaita 
Theme: Adwaita [GTK2/3] 
Icons: Adwaita [GTK2/3] 
Terminal: kgx 
CPU: 13th Gen Intel i7-13620H (16) @ 4.700GHz 
GPU: Intel Raptor Lake-P [UHD Graphics] 
GPU: NVIDIA GeForce RTX 4060 Max-Q / Mobile 
Memory: 4448MiB / 15734MiB 

$ lspci -nn
00:00.0 Host bridge [0600]: Intel Corporation Device [8086:a715]
00:01.0 PCI bridge [0604]: Intel Corporation Raptor Lake PCI Express 5.0 Graphics Port (PEG010) [8086:a70d]
00:02.0 VGA compatible controller [0300]: Intel Corporation Raptor Lake-P [UHD Graphics] [8086:a7a8] (rev 04)
00:04.0 Signal processing controller [1180]: Intel Corporation Raptor Lake Dynamic Platform and Thermal Framework Processor Participant [8086:a71d]
00:06.0 PCI bridge [0604]: Intel Corporation Raptor Lake PCIe 4.0 Graphics Port [8086:a74d]
00:06.2 PCI bridge [0604]: Intel Corporation Device [8086:a73d]
00:08.0 System peripheral [0880]: Intel Corporation GNA Scoring Accelerator module [8086:a74f]
00:0a.0 Signal processing controller [1180]: Intel Corporation Raptor Lake Crashlog and Telemetry [8086:a77d] (rev 01)
00:14.0 USB controller [0c03]: Intel Corporation Alder Lake PCH USB 3.2 xHCI Host Controller [8086:51ed] (rev 01)
00:14.2 RAM memory [0500]: Intel Corporation Alder Lake PCH Shared SRAM [8086:51ef] (rev 01)
00:14.3 Network controller [0280]: Intel Corporation Raptor Lake PCH CNVi WiFi [8086:51f1] (rev 01)
00:15.0 Serial bus controller [0c80]: Intel Corporation Alder Lake PCH Serial IO I2C Controller #0 [8086:51e8] (rev 01)
00:16.0 Communication controller [0780]: Intel Corporation Alder Lake PCH HECI Controller [8086:51e0] (rev 01)
00:1c.0 PCI bridge [0604]: Intel Corporation Alder Lake PCH-P PCI Express Root Port #9 [8086:51bf] (rev 01)
00:1f.0 ISA bridge [0601]: Intel Corporation Raptor Lake LPC/eSPI Controller [8086:519d] (rev 01)
00:1f.3 Audio device [0403]: Intel Corporation Raptor Lake-P/U/H cAVS [8086:51ca] (rev 01)
00:1f.4 SMBus [0c05]: Intel Corporation Alder Lake PCH-P SMBus Host Controller [8086:51a3] (rev 01)
00:1f.5 Serial bus controller [0c80]: Intel Corporation Alder Lake-P PCH SPI Controller [8086:51a4] (rev 01)
01:00.0 VGA compatible controller [0300]: NVIDIA Corporation AD107M [GeForce RTX 4060 Max-Q / Mobile] [10de:28a0] (rev a1)
01:00.1 Audio device [0403]: NVIDIA Corporation Device [10de:22be] (rev a1)
02:00.0 Non-Volatile memory controller [0108]: MAXIO Technology (Hangzhou) Ltd. NVMe SSD Controller MAP1202 (DRAM-less) [1e4b:1202] (rev 01)
03:00.0 Non-Volatile memory controller [0108]: Micron Technology Inc 2550 NVMe SSD (DRAM-less) [1344:5416] (rev 01)
04:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8111/8168/8211/8411 PCI Express Gigabit Ethernet Controller [10ec:8168] (rev 15)
```

</details>

## Power Management
My testing shows suspend issues (tested in GNOME) when using `hardware.nvidia.powerManagement.enabled = true`, regardless of the value of `hardware.nvidia.powerManagement.finegrained`. 
This seems related to this [issue](https://github.com/NixOS/nixpkgs/issues/336723), which is offered a solution in [this discouse thread](https://discourse.nixos.org/t/suspend-resume-cycling-on-system-resume/32322/12) with this config:

<details>

```nix
systemd = {
     services."gnome-suspend" = {
      description = "suspend gnome shell";
      before = [
        "systemd-suspend.service" 
        "systemd-hibernate.service"
        "nvidia-suspend.service"
        "nvidia-hibernate.service"
      ];
      wantedBy = [
        "systemd-suspend.service"
        "systemd-hibernate.service"
      ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = ''${pkgs.procps}/bin/pkill -f -STOP ${pkgs.gnome-shell}/bin/gnome-shell'';
      };
    };
    services."gnome-resume" = {
      description = "resume gnome shell";
      after = [
        "systemd-suspend.service" 
        "systemd-hibernate.service"
        "nvidia-resume.service"
      ];
      wantedBy = [
        "systemd-suspend.service"
        "systemd-hibernate.service"
      ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = ''${pkgs.procps}/bin/pkill -f -CONT ${pkgs.gnome-shell}/bin/gnome-shell'';
      };
    };
  };
```

</details>

At the same time, the Nvidia driver reports power management to still be working even with `nvidia.powerManagement.enable = false`:
```bash
>cat /proc/driver/nvidia/gpus/0000:01:00.0/power
Runtime D3 status:          Enabled (fine-grained)
Video Memory:               Off

GPU Hardware Support:
 Video Memory Self Refresh: Supported
 Video Memory Off:          Supported

S0ix Power Management:
 Platform Support:          Supported
 Status:                    Disabled
```

For more information see the [Nvidia documentation](https://download.nvidia.com/XFree86/Linux-x86_64/565.77/README/powermanagement.html), chapters 21 and 22.
