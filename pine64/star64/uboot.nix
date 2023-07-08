{ fetchFromGitHub, buildUBoot }:

buildUBoot rec {
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "Fishwaldo";
    repo = "u-boot";
    rev = "172b47f62039605d6806fa96bd403c21cda28996"; # Star64 branch
    hash = "sha256-UBPTLbSjDdL6NPUrAdsWcL28QSyiY/5oA+iqxl9dEGY=";
  };

  defconfig = "pine64_star64_defconfig";
  filesToInstall = [
    "u-boot.bin"
    "arch/riscv/dts/pine64_star64.dtb"
    "spl/u-boot-spl.bin"
    "tools/mkimage"
  ];
}
