# Lenovo LOQ 15APH8

Tested on LOQ 15APH8 (82XT) with:
- AMD Phoenix GPU
- NVIDIA GeForce RTX 4050 Max-Q
- AMD Phoenix1 integrated graphics

## Features Requiring Configuration
For optimal power management, consider adding:

```nix
services.power-profiles-daemon.enable = true;
powerManagement.powertop.enable = true;
```
