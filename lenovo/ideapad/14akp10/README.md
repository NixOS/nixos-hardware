# Lenovo Ideapad 5 Slim 14AKP10

These devices support Conversation Mode which charges the battery to 79/80%. See [TLP docs](https://linrunner.de/tlp/settings/bc-vendors.html#lenovo-non-thinkpad-series) and [auto-cpu freq](https://github.com/AdnanHodzic/auto-cpufreq?tab=readme-ov-file#battery-charging-thresholds) to enable it.

Hardware probe for this device: \
[Linux-Hardware](https://linux-hardware.org/?probe=d038397756) \
## Device Information
Details from `tlp-stat`:

```
System         = LENOVO IdeaPad Slim 5 14AKP10 83NJ
BIOS           = R0CN26WW LENOVO
EC Firmware    = 1.26
OS Release     = NixOS 26.11 (Zokor)
Kernel         = 7.0.10-cachyos-lto #1-NixOS SMP PREEMPT_DYNAMIC Tue Jan  1 00:00:00 UTC 1980 x86_64
Boot mode      = UEFI
```

### Extra Configuration
### Bluetooth
This device runs on a RTL8922AE, which does have bluetooth support. To enable: `hardware.bluetooth.enable = true;`.

### Sound
This device uses Sound Open Firmware (SOF). Without it, audio devices (including the microphone) may not work correctly. Enable it with:
`hardware.firmware = [ pkgs.sof-firmware ];`
### Suspend
This device have delays in suspend without it:
`hardware.boot.kernelParams = [ "mem_sleep_default=deep" ];`
### TLP
This hardware-configuration also includes a small TLP configuraiton (without) Conversation mode. This can be explicity disabled with `services.tlp.enable = false`
