# Dell Precision 5490

Linux kernel versions prior to 6.7 may not function correctly with the internal monitor, as official support was introduced in version 6.7 (https://www.phoronix.com/news/Linux-6.7-Intel-Meteor-Lake-Gfx). You can enable experimental support by adding the following parameter:

```
boot.kernelParams = [ "i915.force_probe=7d55" ];
```

However, this may lead to some screen tearing.

If possible, you might benefit from a newer kernel, for example:
```
boot.kernelPackages = pkgs.linuxPackages_latest;
```
as it seems to work without any issues.
