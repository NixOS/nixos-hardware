{
  fetchFromGitHub,
  kernel,
  lib,
  stdenv,
  ...
}:
let
  rev = "101.10.591.52.27-4";
in
stdenv.mkDerivation rec {
  pname = "bcmdhd_sdio";
  version = "${rev}-${kernel.version}";

  passthru.moduleName = "bcmdhd_sdio";

  src = fetchFromGitHub {
    owner = "armbian";
    repo = "bcmdhd-dkms";
    inherit rev;
    hash = "sha256-e9oWorovZrsqm7qZjXygVluahTCIxi4yJy2Pp6lwdl8=";
  };

  sourceRoot = "${src.name}/src";

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  postPatch = ''
    substituteInPlace include/linuxver.h \
      --replace-fail 'del_timer(&((t)->timer))' 'timer_delete(&((t)->timer))'
    substituteInPlace include/linuxver.h \
      --replace-fail 'del_timer_sync(&((t)->timer))' 'timer_delete_sync(&((t)->timer))'
  '';

  buildPhase = ''
    make \
      LINUXDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build \
      ARCH=arm64 \
      CROSS_COMPILE=${stdenv.cc.targetPrefix} \
      bcmdhd_sdio \
      CONFIG_BCMDHD_SDIO=y \
      CONFIG_BCMDHD_DTS=y
  '';

  installPhase = ''
    install -D bcmdhd_sdio.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/rockchip_wlan/rkwifi/bcmdhd/bcmdhd_sdio.ko
    install -D dhd_static_buf_sdio.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/rockchip_wlan/rkwifi/bcmdhd/dhd_static_buf_sdio.ko
  '';

  meta.license = lib.licenses.gpl2Only;
}
