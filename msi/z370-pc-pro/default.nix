{
  imports = [
    ../../common/cpu/intel/coffee-lake/cpu-only.nix
    ../../common/pc/ssd
    ../../common/pc
  ];

  boot.kernelModules = [ "nct6775" ];
}
