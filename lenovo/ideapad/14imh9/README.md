# Lenovo Ideapad 5 Pro 14IMH9 / XiaoXin Pro 14IMH9 2024

These devices support Conservation mode which charges the battery to 79/80%. See [TLP docs](https://linrunner.de/tlp/settings/bc-vendors.html#lenovo-non-thinkpad-series) and [auto-cpu freq](https://github.com/AdnanHodzic/auto-cpufreq?tab=readme-ov-file#battery-charging-thresholds) to enable it.

`lspci`:
```
00:02.0 VGA compatible controller: Intel Corporation Meteor Lake-P [Intel Arc Graphics] (rev 08)
```
There is no dedicated graphics card. See specs [here](https://psref.lenovo.com/syspool/Sys/PDF/IdeaPad/IdeaPad_Pro_5_14IMH9/IdeaPad_Pro_5_14IMH9_Spec.pdf).

## Avoid GPU hangs -> Turn off RC6!
> TL;DR: RC6 *WILL* cause your GPU hangs and there is currently no mainlined way to workaround that. You will have to do it yourself.

RC6 in this laptop is [malfunctioning](https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/14469) and will result in random GPU hangs. There is currently neither a PCODE fix nor a mainlined kernel param to disable RC6 at runtime.

You can, however, apply [this off-tree patch](https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/14469#note_3170015) to the kernel and use `i915.enable_rc6=0` to disable RC6. It is currently not mainlined, so you will have to compile your own kernel, unfortunately.

To avoid further gpu hangs, you should disable RC6 in UEFI settings. It is gated behind advanced BIOS settings and hidden by default. You will have to use something like [Smokeless Runtime EFI Patcher](https://winraid.level1techs.com/t/tool-smokelessruntimeefipatcher-srep/89351) to unlock advanced settings. After that, disabling RC6 in `Power Management` section will do the trick.

NB: `i915.enable_dc=0` does not fix this problem because [hangs happen in the GT unit](https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/14469#note_3191689).

## Extra Configuration
### Bluetooth
To enable bluetooth support, set `hardware.bluetooth.enable = true;`.

### Sound
This laptop need extra firmware for hi-quality sound. To enable that, set `hardware.firmware = [ pkgs.sof-firmware ];`.

## Troubleshooting
### Apps report `VK_ERROR_DEVICE_LOST` after long uptime
Hibernate & Resume your NixOS. It will save your life.
