# Razer Blade 14 (RZ09-0530)

Model year: 2025

## Hardware Specifications

- **Model:** RZ09-0530
- **CPU:** AMD Ryzen AI 9 HX 370 (Strix Point)
- **iGPU:** AMD Radeon 880M / 890M
- **dGPU:** NVIDIA GeForce RTX 5060 Max-Q (Blackwell)
- **Display:** 14" 2560x1600 OLED, 240Hz

## Identifying Your Model

```bash
nix-shell -p dmidecode --run "sudo dmidecode -s system-product-name"
# Should output: Blade 14 - RZ09-0530
```

## Usage

```nix
{
  imports = [
    inputs.nixos-hardware.nixosModules.razer-blade-14-RZ09-0530
  ];
}
```

## Features

This profile configures:

- AMD CPU with microcode updates
- NVIDIA Prime offload (use `nvidia-offload` command for GPU-intensive applications)
- AMD iGPU for early KMS
- Power management for hybrid graphics
- Proper PCI bus IDs for the hybrid GPU setup

## Optional: OpenRazer for RGB Control

If you want to control the Razer RGB keyboard lighting, you can enable OpenRazer:

```nix
{
  hardware.openrazer = {
    enable = true;
    # Disable keyStatistics if using a keyboard remapper like kanata
    keyStatistics = false;
    users = [ "your-username" ];
  };

  # Optional: Polychromatic GUI for RGB control
  environment.systemPackages = [ pkgs.polychromatic ];
}
```

## Known Issues

- None reported yet

## Additional Notes

- The NVIDIA RTX 5060 Max-Q uses the Blackwell architecture and works with the open kernel modules (`hardware.nvidia.open = true`)
- Fine-grained power management is enabled by default for better battery life
- Use `nvidia-offload <command>` to run applications on the discrete GPU


