{
  buildUBoot,
  python3,
  armTrustedFirmwareRK3588,
  fetchFromGitLab,
  fetchFromGitHub,
}:
let
  mntPatches = fetchFromGitLab {
    domain = "source.mnt.re";
    owner = "reform";
    repo = "reform-rk3588-uboot";
    rev = "28289e36cd1cb90b302780e83b014250c880c4ec";
    hash = "sha256-fWGyC+rlfL0NYYRFLvdF7EiO3s9GfFkfhAbTEM5ECAM=";
  };
  rkbin = fetchFromGitHub {
    owner = "rockchip-linux";
    repo = "rkbin";
    rev = "272136301989d493000425935bd4ead0ef04d06b";
    hash = "sha256-qXnuZyFNc6gYTkAtPg1t9WHwj8OiTxOLvsHUuvolK/w=";
  };
in
buildUBoot rec {
  src = fetchFromGitLab {
    domain = "gitlab.collabora.com";
    owner = "hardware-enablement";
    repo = "rockchip-3588/u-boot";
    rev = "424c714eb24731e16509231a817c76d4a6ae0ecc";
    hash = "sha256-26XLcPundNjRcXrSq2V5PaW6M269rsouOV56ymsptzc=";
  };
  version = "424c714eb24731e16509231a817c76d4a6ae0ecc";
  patches = [
    "${mntPatches}/0001-ini-ddrbin-bump.patch"
    "${mntPatches}/0002-add-target-init-mnt-reform-series.patch"
    "${mntPatches}/0003-scripts-dtc-pylibfdt-libfdt-i_shipped-Use-SWIG_AppendOutp.patch"
  ];
  prePatch = ''
    cp ${mntPatches}/*.dts arch/arm/dts/
    cp ${mntPatches}/*_defconfig configs/
  ''; # postPatch is already occupied

  filesToInstall = [
    "idbloader.img"
    "u-boot.itb"
    "rock5b-rk3588.ini"
    "spl/u-boot-spl.bin"
  ];
  variant = "-dsi";
  defconfig = "rk3588-mnt-reform2${variant}_defconfig";
  extraMakeFlags = [
    "BL31=${armTrustedFirmwareRK3588}/bl31.elf"
    "ROCKCHIP_TPL=${rkbin}/bin/rk35/rk3588_ddr_lp4_2112MHz_lp5_2400MHz_v1.18.bin"
  ];
  passthru.rkbin = rkbin;
}
