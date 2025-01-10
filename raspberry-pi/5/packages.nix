{ lib, pkgs, }:
{
  linux_rpi5 = pkgs.linux_rpi4.override {
    rpiVersion = 5;
    argsOverride.defconfig = "bcm2712_defconfig";
  };
}
