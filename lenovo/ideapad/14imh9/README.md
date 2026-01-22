# Lenovo Ideapad 5 Pro 14IMH9 / XiaoXin Pro 14IMH9 2024

These devices support Conservation mode which charges the battery to 79/80%. See [TLP docs](https://linrunner.de/tlp/settings/bc-vendors.html#lenovo-non-thinkpad-series) and [auto-cpu freq](https://github.com/AdnanHodzic/auto-cpufreq?tab=readme-ov-file#battery-charging-thresholds) to enable it.

`lspci`:
```
00:02.0 VGA compatible controller: Intel Corporation Meteor Lake-P [Intel Arc Graphics] (rev 08)
```
There is no dedicated graphics card. See specs [here](https://psref.lenovo.com/syspool/Sys/PDF/IdeaPad/IdeaPad_Pro_5_14IMH9/IdeaPad_Pro_5_14IMH9_Spec.pdf).

## Extra Configuration
### Bluetooth
To enable bluetooth support, set `hardware.bluetooth.enable = true;`.

### Sound
This laptop need extra firmware for hi-quality sound. To enable that, set `hardware.firmware = [ pkgs.sof-firmware ];`.