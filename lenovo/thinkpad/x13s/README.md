# Lenovo X13s

> [!IMPORTANT]
> If you were on an older version of this module, you may experience a change to your WiFi MAC address or the Bluetooth MAC address.
> These were previously defined within this module and they were not generated.
> 
> Use the following configuration to set them to the previous values.
> Consider swapping to the auto-generated MAC addresses in the future.
> Other users of the module will have the same addresses as your machine.
> 
>    ```nix
>    hardware.lenovo.x13s.wifiMAC = "e4:65:38:52:22:a9";
>    hardware.lenovo.x13s.bluetoothMAC = "E4:25:18:22:44:AA";
>    ```

Additional links and information:
- [Debian](https://wiki.debian.org/InstallingDebianOn/Thinkpad/X13s)
- [PostmarketOS](https://wiki.postmarketos.org/wiki/Lenovo_ThinkPad_X13s_(lenovo-21bx))
- [Fedora Project: Thinkpad_X13s](https://fedoraproject.org/wiki/Thinkpad_X13s)
- [jhovald's feature support table](https://github.com/jhovold/linux/wiki/X13s#mainline-feature-support)<sup>last updated: 2025-07-28</sup>

## Recommended configuration

```nix
# mainline does not support TPM at the time of writing.
# system waits for tpm to activate if it is enabled.
# disabling tpm allows the system to boot quicker.
systemd.tpm2.enable = false;
boot.initrd.systemd.tpm2.enable = false;

# enable netoworking
hardware.bluetooth.enable = true;
networking.modemmanager.enable = true;
networking.networkmanager.enable = true;

# native support for hardware.devicetree
boot.loader.systemd-boot.enable = true;
```

## Feature Status

This table is based on jhovald's feature support table.

| Feature | Status |
| --- | --- |
| [Audio](#audio) | 6.5 |
| Backlight | 6.0 |
| Battery | 6.3 |
| [Bluetooth](#bluetooth) | 6.4 |
| [Camera](#camera) | 6.12 |
| CPUFreq | 6.0 |
| Display | 6.3 |
| EFI variables | 6.7 |
| Fingerprint reader | 6.10 |
| GPU | 6.5 |
| Hibernation | - |
| Keyboard | 6.0 |
| [Keyboard Special Keys](#keyboard-special-keys) | - |
| Modem | 6.2 |
| NVMe SSD | 6.2 |
| PCIe x4 | 6.2 |
| Remoteproc | 6.0 |
| RTC | 6.4 |
| Suspend | 6.1 |
| Thermal sensors | 6.2 |
| Touchpad (alternate) | 6.0 (6.4) |
| Touchscreen | 6.0 |
| [TPM](#tpm) | - |
| USB | 6.0 |
| [USB-C DisplayPort Alt Mode](#usb-c-displayport-alt-mode) | 6.3 (partial) |
| USB-PD | 6.16 |
| [Video Acceleration](#video-acceleration) | - |
| [Virtualisation](#virtualisation) | - |
| Watchdog | 6.0 |
| [Wi-Fi](#wi-fi) | 6.4 |

## Audio

System speakers are known to be quiet.
The additonal DSP power monitoring is not complete.
Audio can be boosted using other tools, **BUT** you may destroy your speakers.
Modern laptop and phone speakers use dynamic power to ensure the coils are not overheated.

## Bluetooth
Bluetooth MAC is automatically generated.
The MAC address is based on the system's machine-id.

## Camera
The MIPI camera does work, however, it's not accelerated by the ISP and therefore image processing is done on CPU.
There appears to be an active issue with the camera's powerup sequence.
The camera works one time, and will fail to power up and subsequent times.

Enable the camera patches with the following config:
```nix
hardware.x13s.patches.camera.enable = true;
```

## Keyboard Special Keys

Privacy keys (camera, and microphone) [appear](https://lore.kernel.org/linux-arm-msm/cf17e2ba-0510-4189-a590-00d10760b8d7@oss.qualcomm.com/) to be managed by the embedded controller.
The embedded controller will also be needed to save and restore keyboard backlight configuration handed off by UEFI.

## TPM
Currently TPM does not work on the mainline kernel. Disable in your config to help boot speed.

[esp0xdeadbeef](https://github.com/esp0xdeadbeef) has a set of [kernel patches](https://github.com/esp0xdeadbeef/nixos/blob/72060c0f01456f4f3038fa276c1173dcee123c1d/nixos/laptop/l-portal/hardware/tpm.nix#L24) to get TPM working for the x13s. Make sure to use the same pinned version of nixpkgs as kernel patches do not always apply across kernel updates. Expect building the kernel with the patches to take several hours. Patches may not have been reviewed by kernel maintainers.

Enable the TPM patches with the following config:
```nix
hardware.x13s.patches.tpm.enable = true;
```

## USB-C DisplayPort Alt Mode

Multi-Stream Transport, MST, is being worked upstream.
https://lore.kernel.org/all/20260831-msm-dp-mst-v6-0-c91d35d6fb9e@oss.qualcomm.com/
https://lore.kernel.org/all/20260629-msm-dp-msttypec-v1-0-646a10256233@oss.qualcomm.com/

## Video Acceleration

Additional video acceleration will come from Iris support.
https://lore.kernel.org/linux-media/?q=sc8280xp+iris

## Virtualisation

We have an el2 devicetree. `slbounce` *may* be able to get kvm working.
Other devices may have issues with working as expected.

## Wi-Fi
Wi-Fi MAC address is automatically generated.
The MAC address is based on the system's machine-id.

