# [Framework Laptop 16 AMD AI 300 Series](https://frame.work/)

## NVIDIA dGPU Module

If you have an NVIDIA dGPU module (GeForce RTX 5070 or similar), use the nvidia submodule:

```nix
{
  imports = [
    nixos-hardware.nixosModules.framework-16-amd-ai-300-series-nvidia
  ];
}
```

This enables hybrid graphics with PRIME offload: the AMD iGPU runs by default for better battery life, and the NVIDIA dGPU can be used on demand with `nvidia-offload <command>`.

**IMPORTANT:** You MUST override the PCI bus IDs for your specific system. The default values are examples only and will likely not match your hardware. Due to Framework 16's modular design, bus IDs vary depending on installed expansion cards and NVMe drives:

```nix
{
  hardware.nvidia.prime = {
    amdgpuBusId = "PCI:195:0:0";   # Adjust to your system
    nvidiaBusId = "PCI:194:0:0";   # Adjust to your system
  };
}
```

Find your bus IDs with:

```sh
$ lspci | grep -E "VGA|3D|Display"
c2:00.0 VGA compatible controller: NVIDIA Corporation ...
c3:00.0 Display controller: Advanced Micro Devices ...
```

Convert the hex bus ID to decimal (e.g., `c2:00.0` → `PCI:194:0:0`, `c3:00.0` → `PCI:195:0:0`).

See also [NVIDIA](https://wiki.nixos.org/wiki/NVIDIA) on the NixOS Wiki.

## Updating Firmware

Everything is updateable through fwupd, so it's enabled by default.

To get the latest firmware, run:

```sh
$ fwupdmgr refresh
$ fwupdmgr update
```

- [Latest Update](https://fwupd.org/lvfs/devices/work.frame.Laptop16.RyzenAI300.BIOS.firmware)
