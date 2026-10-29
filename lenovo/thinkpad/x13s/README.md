# Lenovo X13s

[Debian](https://wiki.debian.org/InstallingDebianOn/Thinkpad/X13s)
[PostmarketOS](https://wiki.postmarketos.org/wiki/Lenovo_ThinkPad_X13s_(lenovo-21bx))

## Camera
The MIPI camera does work, however, it's not accelerated by the ISP and therefore image processing is done on CPU.

## Wifi and Bluetooth MAC addresses
Wi-Fi MAC address is automatically generated.

Bluetooth MAC is automatically generated.

**Note**
If you were on an older version of this module, you may experience a change to your WiFi MAC address or the Bluetooth MAC address. These were previously defined within this module and they were not generated.

Use the following configuration to set them to the previous values. Consider swapping to the auto-generated MAC addresses in the future. Other users of the module will have the same addresses as your machine.

```nix
hardware.lenovo.x13s.wifiMAC = "e4:65:38:52:22:a9";
hardware.lenovo.x13s.bluetoothMAC = "E4:25:18:22:44:AA";
```

## TPM
Currently TPM does not work. Disable in your config to help boot speed.

```nix
systemd.tpm2.enable = false;
boot.initrd.systemd.tpm2.enable = false;
```

## Recommended configurations

```nix
systemd.tpm2.enable = false;
boot.initrd.systemd.tpm2.enable = false;
hardware.bluetooth.enable = true;
networking.modemmanager.enable = true;
networking.networkmanager.enable = true;
boot.loader.systemd-boot.enable = true;
```
