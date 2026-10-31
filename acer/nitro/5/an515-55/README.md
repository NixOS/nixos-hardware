# Acer Nitro 5 (AN515-55)

## Hardware Configuration

- Intel Core i5-10500H
- Intel UHD Graphics + NVIDIA GeForce GTX 1650 Mobile (Turing, TU117M)
- M.2 NVMe SSD

## Notes

- PRIME offload works via `nvidia-offload <cmd>` (enabled by default
  via `common/gpu/nvidia/prime.nix`). GPU runtime D3 is not supported
  on this chassis — the discrete GPU stays powered on at all times,
  even when idle.
- NVIDIA open kernel modules work on this Turing GPU (enabled by
  default via `common/gpu/nvidia/turing`), tested with the 595 series.
- `acer_wmi` loads and registers the `platform_profile` driver, but
  no sysfs interface is exposed (`/sys/firmware/acpi/platform_profile`
  does not exist). Fan/performance modes are only reachable through
  Acer's proprietary WMI methods (NitroSense on Windows).
- Keyboard backlight is not exposed via the standard LED class
  (`/sys/class/leds`) — `brightnessctl` only controls panel brightness.
