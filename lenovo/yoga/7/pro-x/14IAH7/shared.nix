{
  imports = [
    ../shared
    ../../../../../common/cpu/intel/alder-lake
    ../../../../../common/gpu/intel/alder-lake
  ];

  boot.kernelModules = [ "kvm-intel" ];
}
