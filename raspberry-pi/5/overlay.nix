final: _prev: {
  ubootRaspberryPi5_rev1_0 = final.buildUBoot {
    defconfig = "rpi_arm64_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    filesToInstall = [ "u-boot.bin" ];
  };

  ubootRaspberryPi5_rev1_1 = final.buildUBoot {
    defconfig = "rpi_arm64_defconfig";
    # Mote: this patch can be removed once U-Boot starts setting
    # `fdtfile=bcm2712d0-rpi-5.dtb` automatically for rev1.1 boards
    patches = [ ./uboot-rpi5-bcm2712d0.patch ];
    extraMeta.platforms = [ "aarch64-linux" ];
    filesToInstall = [ "u-boot.bin" ];
  };
}
