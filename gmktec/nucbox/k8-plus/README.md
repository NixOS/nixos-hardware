# GMKtec NucBox K8 Plus

> [!NOTE]
> The [GMKtec NucBox K11](../k11) is a hardware twin of the K8 Plus.

## Audio Quirk & WirePlumber Profile

The onboard Realtek ALC269VC audio codec routes analog audio to the front 3.5mm combo audio jack via the AMD Ryzen HD Audio Controller (PCI ID `1022:15e3`). Because the mini PC chassis does not have internal speakers or an internal microphone, the default ALSA profile set creates phantom internal speaker and microphone endpoints. When headphones are unplugged, sound servers like PipeWire/WirePlumber may route audio to nonexistent speakers rather than falling back to HDMI or Bluetooth devices.

This module installs a custom ALSA card profile set (`gmktec-nucbox-k8-plus-k11.conf`) and a WirePlumber monitor rule matching product ID `0x15e3` to map only the headphone output and headset microphone. When nothing is plugged into the 3.5mm jack, the analog port is marked as unplugged/unavailable, allowing automatic and seamless fallback to alternate audio sinks.
