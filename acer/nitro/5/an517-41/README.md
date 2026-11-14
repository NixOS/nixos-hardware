# Acer Nitro 5 AN517-41

## Hardware

- CPU: AMD Ryzen 7 5800H
- Integrated GPU: AMD Radeon Graphics
- Dedicated GPU: NVIDIA GeForce RTX 3060 Laptop GPU
- SSD: Sandisk Corp WD Blue SN550 NVMe SSD

## Notes

- NVIDIA Dynamic Boost is enabled by default, leading to improved performance
  and reduced power consumption. See the [Hardware Requirements][nv-dynboost].
- NVIDIA Power Management has also been enabled by default to improve
  suspend/resume stability. More info is in the [NVIDIA docs][nv-powermgmt].
- Acer's battery health mode can be toggled using
  `hardware.acer.battery.enableHealthMode`. When enabled, battery charge is
  limited to 80%, which may improve battery life. It can be temporarily
  toggled until next boot with `acer_battery_toggle_health_mode`.

[nv-dynboost]: https://download.nvidia.com/XFree86/Linux-x86_64/525.60.13/README/dynamicboost.html
[nv-powermgmt]: https://download.nvidia.com/XFree86/Linux-x86_64/435.17/README/powermanagement.html
