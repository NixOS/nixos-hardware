{
  stdenv,
  reformDebianPackages,
  kernelSource,
  quilt,
}:
stdenv.mkDerivation {
  name = "mnt-dts-patch";
  nativeBuildInputs = [ quilt ];
  buildCommand = ''
    cp -r --reflink=auto ${reformDebianPackages}/linux/* .
    mkdir -p linux/debian/patches/reform
    cp -r --reflink=auto ${kernelSource}/* linux
    chmod +w -R .
    env --chdir=linux QUILT_PATCHES=debian/patches quilt new reform/dts.patch
    env --chdir=linux QUILT_PATCHES=debian/patches quilt add arch/arm64/boot/dts/freescale/fsl-ls1028a-mnt-reform2.dts
    cp fsl-ls1028a-mnt-reform2.dts linux/arch/arm64/boot/dts/freescale/fsl-ls1028a-mnt-reform2.dts
    env --chdir=linux QUILT_PATCHES=debian/patches quilt add arch/arm64/boot/dts/freescale/imx8mq-mnt-reform2-hdmi.dts
    cp imx8mq-mnt-reform2-hdmi.dts linux/arch/arm64/boot/dts/freescale/imx8mq-mnt-reform2-hdmi.dts
    env --chdir=linux QUILT_PATCHES=debian/patches quilt add arch/arm64/boot/dts/freescale/Makefile
    sed -i '/fsl-ls1028a-rdb.dtb/a dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-ls1028a-mnt-reform2.dtb' linux/arch/arm64/boot/dts/freescale/Makefile
    sed -i '/imx8mq-mnt-reform2.dtb/a dtb-$(CONFIG_ARCH_MXC) += imx8mq-mnt-reform2-hdmi.dtb' linux/arch/arm64/boot/dts/freescale/Makefile
    env --chdir=linux QUILT_PATCHES=debian/patches quilt add arch/arm64/boot/dts/freescale/imx8mp-mnt-pocket-reform.dts
    cp imx8mp-mnt-pocket-reform.dts linux/arch/arm64/boot/dts/freescale/imx8mp-mnt-pocket-reform.dts
    env --chdir=linux QUILT_PATCHES=debian/patches quilt add arch/arm64/boot/dts/freescale/imx8mp-mnt-reform2.dts
    cp imx8mp-mnt-reform2.dts linux/arch/arm64/boot/dts/freescale/imx8mp-mnt-reform2.dts
    sed -i '/imx8mq-mnt-reform2.dtb/a dtb-$(CONFIG_ARCH_MXC) += imx8mp-mnt-pocket-reform.dtb' linux/arch/arm64/boot/dts/freescale/Makefile
    sed -i '/imx8mq-mnt-reform2.dtb/a dtb-$(CONFIG_ARCH_MXC) += imx8mp-mnt-reform2.dtb' linux/arch/arm64/boot/dts/freescale/Makefile
    env --chdir=linux QUILT_PATCHES=debian/patches quilt add arch/arm64/boot/dts/amlogic/meson-g12b-bananapi-cm4-mnt-pocket-reform.dts
    cp meson-g12b-bananapi-cm4-mnt-pocket-reform.dts linux/arch/arm64/boot/dts/amlogic/meson-g12b-bananapi-cm4-mnt-pocket-reform.dts
    env --chdir=linux QUILT_PATCHES=debian/patches quilt add arch/arm64/boot/dts/amlogic/Makefile
    sed -i '/meson-g12b-bananapi-cm4-mnt-reform2.dtb/a dtb-$(CONFIG_ARCH_MESON) += meson-g12b-bananapi-cm4-mnt-pocket-reform.dtb' linux/arch/arm64/boot/dts/amlogic/Makefile
    env --chdir=linux QUILT_PATCHES=debian/patches quilt add arch/arm64/boot/dts/rockchip/rk3588-mnt-reform2.dts
    cp rk3588-mnt-reform2.dts linux/arch/arm64/boot/dts/rockchip/rk3588-mnt-reform2.dts
    env --chdir=linux QUILT_PATCHES=debian/patches quilt add arch/arm64/boot/dts/rockchip/rk3588-mnt-reform2-dsi.dts
    cp rk3588-mnt-reform2-dsi.dts linux/arch/arm64/boot/dts/rockchip/rk3588-mnt-reform2-dsi.dts
    env --chdir=linux QUILT_PATCHES=debian/patches quilt add arch/arm64/boot/dts/rockchip/rk3588-mnt-pocket-reform.dts
    cp rk3588-mnt-pocket-reform.dts linux/arch/arm64/boot/dts/rockchip/rk3588-mnt-pocket-reform.dts
    env --chdir=linux QUILT_PATCHES=debian/patches quilt add arch/arm64/boot/dts/rockchip/rk3588-mnt-reform-next.dts
    cp rk3588-mnt-reform-next.dts linux/arch/arm64/boot/dts/rockchip/rk3588-mnt-reform-next.dts
    env --chdir=linux QUILT_PATCHES=debian/patches quilt add arch/arm64/boot/dts/rockchip/Makefile
    sed -i '/rk3588-mnt-reform2.dtb/a dtb-$(CONFIG_ARCH_ROCKCHIP) += rk3588-mnt-reform2-dsi.dtb' linux/arch/arm64/boot/dts/rockchip/Makefile
    sed -i '/rk3588-mnt-reform2-dsi.dtb/a dtb-$(CONFIG_ARCH_ROCKCHIP) += rk3588-mnt-reform-next.dtb' linux/arch/arm64/boot/dts/rockchip/Makefile
    sed -i '/rk3588-mnt-reform-next.dtb/a dtb-$(CONFIG_ARCH_ROCKCHIP) += rk3588-mnt-pocket-reform.dtb' linux/arch/arm64/boot/dts/rockchip/Makefile
    env --chdir=linux QUILT_PATCHES=debian/patches quilt refresh
    cp linux/debian/patches/reform/dts.patch $out
  '';
}
