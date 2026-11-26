# MacBook Air 7,X

### For wifi driver
broadcomt_sta was the best working driver I could find, however on the normal kernel, you need to `sudo modprobe -r wl` and `sudo modprobe wl`, however it was fully working on the zen kernel.


# MacBook Air 7,2

## Issues

> Wifi Driver doesn't work 

### Solution
* generated NixOS-Configuration via nixos-generate config on MacBook to load following modules:

```nix
  boot.kernelModules = [ "kvm-intel" "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
```


> Camera doesn't work

### Solution

```nix
  hardware.facetimehd.enable = true;
```

* when added this line of code, another driver was loaded for the network controller, so wifi stopped working. 
* by adding the modules to boot.initrd. both wifi and camera was working:

### Solution 
```nix
  boot.initrd.kernelModules = [ "kvm-intel" "wl" ]; 
```
