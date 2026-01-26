# System76 Oryx Pro

## Supported Models

This configuration supports System76 Oryx Pro laptops with the following specifications:

- **CPU**: Intel Alder Lake-P series (12th gen)
- **iGPU**: Intel Iris Xe Graphics
- **dGPU**: NVIDIA GeForce RTX 3070 Ti Laptop (GA104 - Ampere architecture)
- **Graphics**: Hybrid graphics with NVIDIA Optimus PRIME
- **External Display**: HDMI output connected to NVIDIA GPU

## Configuration Details

### NVIDIA PRIME Setup

This configuration uses **PRIME Sync Mode** which:

- Keeps the NVIDIA GPU active at all times
- Enables HDMI output (required since HDMI is connected to NVIDIA GPU)
- Provides stable external display support
- Uses more power but eliminates switching delays
- Works well with Wayland desktop environments

### Key Features

- **Open Source NVIDIA Kernel Modules**: Enabled by default (recommended for RTX 30 series)
- **Production NVIDIA Drivers**: Uses the stable production branch (~550.x series)
- **Wayland Support**: Includes environment variables for proper Wayland+NVIDIA operation
- **System76 Firmware**: Enables System76-specific hardware support

### Bus IDs

- **Intel iGPU**: `PCI:0:2:0`
- **NVIDIA dGPU**: `PCI:1:0:0`

## Usage

Add this configuration to your `configuration.nix`:

```nix
{
  imports = [
    <nixos-hardware/system76/oryp>
  ];
}
```

## Known Issues and Solutions

### High Refresh Rate Display Flickering

If you experience external monitor flickering with high refresh rate displays (144Hz), reduce the refresh rate to 60Hz:

```bash
# Set laptop display to 60Hz
kscreen-doctor output.eDP-1.mode.2

# Set external monitor to 60Hz  
kscreen-doctor output.HDMI-A-1.mode.15
```

Alternatively, switch to X11 for better high refresh rate stability:

```nix
services.displayManager.defaultSession = "plasmax11";
```

### Power Management

For better battery life when not using external displays, you can switch to **Offload Mode**:

```nix
hardware.nvidia.prime = {
  offload.enable = true;
  sync.enable = false;
};
```

Note: Offload mode may not support HDMI output depending on hardware wiring.

## Verification

After applying the configuration and rebooting, verify the setup:

```bash
# Check NVIDIA driver status
nvidia-smi

# Verify OpenGL renderer
glxinfo | grep "OpenGL renderer"

# Check display configuration
kscreen-doctor -o
```

## References

- [System76 Oryx Pro Specifications](https://system76.com/laptops/oryx)
- [NixOS NVIDIA Wiki](https://nixos.wiki/wiki/Nvidia)
- [NVIDIA PRIME Documentation](https://wiki.archlinux.org/title/PRIME)