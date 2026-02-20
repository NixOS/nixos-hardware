{ config, ... }:
{
  imports = [
    ../../common/cpu/amd
    ../../common/pc/ssd
    ../../common/pc
  ];

  boot.extraModulePackages = with config.boot.kernelPackages; [
    nct6687d
  ];

  boot.kernelModules = [ "nct6687d" ];
}
