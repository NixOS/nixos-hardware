{ armTrustedFirmwareRK3588
, buildUBoot
, lib
, rkbin
, enableUart ? true
, baudRate ? 1500000
, ...
}:
(buildUBoot {
  defconfig = "orangepi-5-max-rk3588_defconfig";
  BL31 = "${armTrustedFirmwareRK3588}/bl31.elf";
  ROCKCHIP_TPL = rkbin.TPL_RK3588;

  extraPatches = [
    ./orangepi-5-max-dtb.patch
  ];

  preConfigure = ''
    cp --no-preserve=mode ${./orangepi-5-max-rk3588_defconfig} configs/orangepi-5-max-rk3588_defconfig
    cp --no-preserve=mode ${./rk3588-orangepi-5-max.dts} arch/arm/dts/rk3588-orangepi-5-max.dts
    cp --no-preserve=mode ${./rk3588-orangepi-5-max-u-boot.dtsi} arch/arm/dts/rk3588-orangepi-5-max-u-boot.dtsi
 
    sed -i "s/^CONFIG_BAUDRATE=1500000/CONFIG_BAUDRATE=${toString baudRate}/" configs/orangepi-5-max-rk3588_defconfig
    sed -i "s/serial2:1500000n8/serial2:${toString baudRate}n8/" arch/arm/dts/rk3588-orangepi-5-max.dts
  '' + lib.optionalString (!enableUart) ''
    sed -i "s/^CONFIG_DEBUG_UART=y/# CONFIG_DEBUG_UART is not set/" configs/orangepi-5-max-rk3588_defconfig
  '';

  filesToInstall = [ "u-boot.itb" "idbloader.img" "u-boot-rockchip.bin" "u-boot-rockchip-spi.bin" ];
})
