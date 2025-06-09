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
    rev = "55bca0174e7bb449e96028d64ad8348f5af35977";
    hash = "sha256-A3u1afGK65cGOwENQtu8Hh+fLsSDNxc3rEebkd3QOic=";
  };
  rkbin = fetchFromGitHub {
    owner = "rockchip-linux";
    repo = "rkbin";
    rev = "f43a462e7a1429a9d407ae52b4745033034a6cf9";
    hash = "sha256-geESfZP8ynpUz/i/thpaimYo3kzqkBX95gQhMBzNbmk=";
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
  defconfig = "mnt-reform2-rk3588${variant}_defconfig";
  extraMakeFlags = [
    "BL31=${armTrustedFirmwareRK3588}/bl31.elf"
    "ROCKCHIP_TPL=${rkbin}/bin/rk35/rk3588_ddr_lp4_2112MHz_lp5_2400MHz_v1.18.bin"
  ];
  passthru.rkbin = rkbin;
}
