# Lenovo X13s

[Debian](https://wiki.debian.org/InstallingDebianOn/Thinkpad/X13s)
[PostmarketOS](https://wiki.postmarketos.org/wiki/Lenovo_ThinkPad_X13s_(lenovo-21bx))

## Camera
The MIPI camera does work, however, it's not accelerated by the ISP and therefore image processing is done on CPU.

## Wifi and Bluetooth MAC addresses
Wifi mac address is automatically generated.

Bluetooth mac is automatically generated.

## TPM
Currently TPM does not work. Disable in your config to help boot speed.

```nix
systemd.tpm2.enable = false;
```

## Recommends configurations

```nix
systemd.tpm2.enable = false;
hardware.bluetooth.enable = true;
networking.modemmanager.enable = true;
networking.networkmanager.enable = true;
boot.loader.systemd-boot.enable = true;
```