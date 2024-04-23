{
  imports = [
    ../../common/cpu/intel/comet-lake
  ];

  boot.initrd.kernelModules = [
    "sdhci_pci" # 16G eMMC on board
  ];
}
