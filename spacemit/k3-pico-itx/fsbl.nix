{
  buildUBoot,
  fetchFromGitHub,
}:

buildUBoot {
  version = "2022.10-k3-br-v1.0.y";

  src = fetchFromGitHub {
    owner = "liberodark";
    repo = "spacemit-uboot-2022.10";
    rev = "368953aa0b648528ddafa5b6baa73507448ab94d";
    hash = "sha256-LTtxHzL5aoMLlv8DsgEoyIM0JrwYYzNlHCAmXzixScI=";
  };

  defconfig = "k3_defconfig";

  filesToInstall = [
    "FSBL.bin"
    "bootinfo_block.bin"
    "bootinfo_spinor.bin"
    "bootinfo_spinand.bin"
  ];
}
