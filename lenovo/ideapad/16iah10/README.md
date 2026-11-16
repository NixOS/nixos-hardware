# Lenovo IdeaPad Pro 5 16IAH10

NixOS hardware profile for the **Lenovo IdeaPad Pro 5 16IAH10** (DMI product name `83JM`).

## Specifications

- **CPU:** Intel Core Ultra 9 285H (Arrow Lake-P)
- **iGPU:** Intel Arc Pro 130T/140T (`8086:7d51`) at `PCI:0:2:0`
- **dGPU (optional):** NVIDIA GeForce RTX 5050 Mobile (GB207M / Blackwell, `10de:2d98`) at `PCI:1:0:0`
- **NPU:** Intel NPU Accelerator (`8086:7d1d`)
- **Wireless:** Intel Wi-Fi 7 BE200 (`iwlwifi`)

## Kernel Requirement

Linux kernel **6.8 or newer** (recommended: `pkgs.linuxPackages_latest`) is required for proper Arrow Lake-P support and the Intel `xe` graphics driver.

## Battery Conservation Mode

This device supports Lenovo Battery Conservation mode (limits charging threshold to ~80% to preserve battery lifespan) via the native `ideapad_acpi` driver (`/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode`).

To manage it automatically, see [TLP documentation](https://linrunner.de/tlp/settings/bc-vendors.html#lenovo-non-thinkpad-series) or [auto-cpufreq](https://github.com/AdnanHodzic/auto-cpufreq#battery-charging-thresholds).

## NVIDIA Dedicated Graphics (PRIME Offload)

For laptop variants equipped with the NVIDIA GeForce RTX 5050 Mobile dGPU, import the dedicated NVIDIA submodule:

### Flake configuration:
```nix
imports = [
  nixos-hardware.nixosModules.lenovo-ideapad-16iah10-nvidia
];
```

### Channels configuration:
```nix
imports = [
  <nixos-hardware/lenovo/ideapad/16iah10/nvidia>
];
```

This submodule configures PRIME render offload with open kernel modules (`hardware.nvidia.open = true;`) and the verified PCI bus IDs (`PCI:0:2:0` for Intel and `PCI:1:0:0` for NVIDIA).

## Thermal and Fan Profiles

Thermal management is handled by `services.thermald.enable = true;`.

Fan profiles can be toggled dynamically via ACPI platform profiles (`/sys/firmware/acpi/platform_profile`):
- `performance`
- `balanced`
- `low-power`
