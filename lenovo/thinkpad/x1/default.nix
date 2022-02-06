{
  imports = [
    ../.
    ../../../common/cpu/intel
  ];

  boot.kernelParams = [ "intel_iommu=on" ];
}
