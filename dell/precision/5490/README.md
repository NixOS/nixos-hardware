# Dell Precision 5490

The internal monitor needs Linux Kernel >= 6.7 so enabling hybrid graphics does not work out of the box in 24.05. Setting

```
boot.kernelParams = [ "i915.force_probe=7d55" ];
```

helped but introduced some screen tearing.

Setting
```
boot.kernelPackages = pkgs.linuxPackages_latest;
```
in nixos-stable worked with no problems.
