{
  imports = [
    ../../common/cpu/intel/comet-lake
  ];

  boot.initrd.kernelModules = [
    "sdhci_pci" # 16G eMMC on board
  ];

  boot.kernelModules = [
    "it87" # ITE IT8786E Super IO Sensors
  ];
}
