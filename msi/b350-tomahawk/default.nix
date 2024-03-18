{
  imports = [
    ../../common/cpu/amd
    ../../common/pc/ssd
    ../../common/pc
  ];

  boot.kernelModules = ["nct6775"];
}
