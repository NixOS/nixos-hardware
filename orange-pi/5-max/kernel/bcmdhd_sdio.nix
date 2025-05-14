{ fetchFromGitHub
, kernel
, lib
, stdenv
, ...
}:
let
  rev = "101.10.591.52.27-1";
in
stdenv.mkDerivation rec {
  pname = "bcmdhd_sdio";
  version = "${rev}-${kernel.version}";

  passthru.moduleName = "bcmdhd_sdio";

  src = fetchFromGitHub {
    owner = "Joshua-Riek";
    repo = "bcmdhd-dkms";
    inherit rev;
    hash = "sha256-vOpyQB5HMJxL8vKdyHDz3d5R6LWC9yUcjH50Nwbch38=";
  };

  sourceRoot = "${src.name}/src";

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildPhase = ''
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build \
      M=$PWD \
      ARCH=arm64 \
      CROSS_COMPILE=${stdenv.cc.targetPrefix} \
      modules \
      CONFIG_BCMDHD_SDIO=y \
      CONFIG_BCMDHD_PCIE= \
      CONFIG_BCMDHD_USB=
  '';

  installPhase = ''
    install -D bcmdhd_sdio.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/rockchip_wlan/rkwifi/bcmdhd/bcmdhd_sdio.ko
    install -D dhd_static_buf_sdio.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/rockchip_wlan/rkwifi/bcmdhd/dhd_static_buf_sdio.ko
  '';

  meta.license = lib.licenses.gpl2Only;
}
