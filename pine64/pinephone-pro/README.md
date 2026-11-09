# Pine64 PinePhone Pro

## Bootloader

Either [Tow-Boot](https://github.com/Tow-Boot/Tow-Boot) or Megi's [rk2aw](https://xnux.eu/rk2aw/) are recommended to
allow boot via `boot.loader.generic-extlinux-compatible`. rk2aw features a touch-based boot selection which should
provide the ability to choose the NixOS generation.

## Known Issues

- The `brcmfmac` driver regularly spews the following error `brcmf_set_channel: set chanspec 0x???? fail, reason -52`
  this has been somewhat alleviated by [disabling SAE](./wifi.nix#L7) to the point of allowing WiFi to function
  but the issue still remains.
