# [Framework Laptop 16 — AMD Ryzen AI 300 Series](https://frame.work/)

## Recommended modules

### Base (no NVIDIA dGPU module)

Use the base module:

```nix
{
  imports = [
    nixos-hardware.nixosModules.framework-16-amd-ai-300-series
  ];
}
```

### NVIDIA dGPU module (RTX 5070 etc.)

If you have the Framework 16 NVIDIA dGPU module (GeForce RTX 5070 or similar), use the NVIDIA submodule:

```nix
{
  imports = [
    nixos-hardware.nixosModules.framework-16-amd-ai-300-series-nvidia
  ];
}
```

This enables hybrid graphics with PRIME offload: the AMD iGPU runs by default for better battery life, and the NVIDIA dGPU can be used on demand with `nvidia-offload <command>`.

#### IMPORTANT: You MUST override the PCI bus IDs for your specific system!

The default values are examples only and will likely not match your hardware. Due to Framework 16's modular design, bus IDs vary depending on installed expansion cards and NVMe drives:

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
$ nix-shell -p pciutils --run 'lspci | grep -E "VGA|3D|Display"'
c2:00.0 VGA compatible controller: NVIDIA Corporation ...
c3:00.0 Display controller: Advanced Micro Devices ...
```

Convert the hex bus ID to decimal (e.g., `c2:00.0` → `PCI:194:0:0`, `c3:00.0` → `PCI:195:0:0`).

Helper:

```sh
# Replace BDF with the lspci value like c2:00.0
BDF="c2:00.0"
BUS="${BDF%%:*}"; REST="${BDF#*:}"
DEV="${REST%%.*}"; FUN="${REST#*.}"
printf 'PCI:%d:%d:%d\n' "$((16#$BUS))" "$((16#$DEV))" "$FUN"
```

#### Validate hybrid / offload behavior

```sh
# Default should use AMD
nix-shell -p mesa-demos --run 'glxinfo -B | grep -E "OpenGL vendor|OpenGL renderer"'

# Offload should use NVIDIA
nix-shell -p mesa-demos --run 'nvidia-offload glxinfo -B | grep -E "OpenGL vendor|OpenGL renderer"'
```

To check whether the NVIDIA GPU is runtime-suspending at idle:

```sh
# Reuse $BDF from above
cat /sys/bus/pci/devices/0000:$BDF/power/runtime_status
```

Note: running `nvidia-smi` can wake the GPU, so it is not a reliable “is it sleeping?” probe.

#### Optional: Battery-saver boot entry

If you want an easy “iGPU-only” boot entry (to maximize battery life and avoid loading NVIDIA at all), you can enable the PRIME battery saver specialisation:

```nix
{
  hardware.nvidia.primeBatterySaverSpecialisation = true;
}
```

This creates an additional boot entry tagged `battery-saver`.

#### Troubleshooting notes

* If suspend/resume fails after heavy GPU/VRAM usage, see the NixOS NVIDIA wiki for power management / VRAM save notes: https://wiki.nixos.org/wiki/NVIDIA

## Firmware updates (fwupd)

Firmware is updatable via `fwupd` (enabled by default). To get the latest firmware:

```sh
$ fwupdmgr refresh
$ fwupdmgr update
```

- [Latest BIOS update on LVFS](https://fwupd.org/lvfs/devices/work.frame.Laptop16.RyzenAI300.BIOS.firmware)
