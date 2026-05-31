<!-- vim: set fenc=utf-8 ts=2 sw=2 sts=-1 sr et si tw=0 fdm=marker fmr={{{,}}}: -->
# [ASUS TUF Gaming A15 FA506NCR](https://www.asus.com/laptops/for-gaming/tuf-gaming/2021-asus-tuf-gaming-a15/)
This imports common modules for the AMD CPU, NVIDIA GPU (no iGPU), basic laptop configs, basic SSD configs and configs for ASUS batteries.
On top of that, it enables modesetting for the NVIDIA GPU.

This model is unusual in that it only has a discrete NVIDIA RTX 3050 Mobile GPU with no integrated graphics.
## Useful other things to consider in your configuration
### Battery charging limit
Due to the common module for ASUS batteries, you can make your battery only charge up to a certain percentage to improve its life. You can place something similar to the following in your configuration to enable it:
```nix
hardware.asus.battery = {
  chargeUpto             = 85;   # Maximum level of charge for your battery, as a percentage.
  enableChargeUptoScript = true; # Whether to add charge-upto to environment.systemPackages. `charge-upto 85` temporarily sets the charge limit to 85%.
};
```
### OpenRGB
You can use OpenRGB to control the RGB keyboard on this laptop. There's also plugins for it to get some extra RGB lighting modes if you wish. You can place the following in your configuration to enable it:
```nix
boot.kernelModules               = [ "i2c-dev" ];
hardware.i2c.enable              = true;
services.udev.packages           = [ pkgs.openrgb ];
services.hardware.openrgb.enable = true;
```