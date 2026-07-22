{
  buildUBoot,
  fetchFromGitHub,
}:

buildUBoot {
  version = "2022.10-k1-bl-v2.2.y";

  src = fetchFromGitHub {
    owner = "liberodark";
    repo = "spacemit-uboot-2022.10";
    rev = "d61c8c77e241314438dce31d9ff1b1cbd9d53688";
    hash = "sha256-hYrA0lwZGn0IfzWp6CGghtPK7c85WG69Upd25ie+vbQ=";
  };

  defconfig = "k1_defconfig";

  filesToInstall = [
    "FSBL.bin"
    "bootinfo_sd.bin"
    "bootinfo_emmc.bin"
    "bootinfo_spinor.bin"
    "bootinfo_spinand.bin"
  ];
}
