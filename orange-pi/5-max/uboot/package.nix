{
  ubootOrangePi5Max,
  lib,
  enableUart ? true,
  baudRate ? 1500000,
  ...
}:
ubootOrangePi5Max.overrideAttrs (_prev: {
  preConfigure =
    ''
      sed -i "s/^CONFIG_BAUDRATE=1500000/CONFIG_BAUDRATE=${toString baudRate}/" configs/orangepi-5-max-rk3588_defconfig
      sed -i "s/serial2:1500000n8/serial2:${toString baudRate}n8/" dts/upstream/src/arm64/rockchip/rk3588-orangepi-5.dtsi
    ''
    + lib.optionalString (!enableUart) ''
      sed -i "s/^CONFIG_DEBUG_UART=y/# CONFIG_DEBUG_UART is not set/" configs/orangepi-5-max-rk3588_defconfig
    '';
})
