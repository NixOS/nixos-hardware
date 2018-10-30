{
  imports = [
    ../.
    ../../../common/cpu/intel
  ];

  boot.kernelModules = [ "tpm-rng" ];
}
