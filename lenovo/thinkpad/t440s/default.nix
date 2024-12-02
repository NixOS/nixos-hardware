{
  imports = [
    ../.
    ../../../common/cpu/intel
  ];

  boot = {
    # TODO: probably enable tcsd? Is this line necessary?
    kernelModules = [ "tpm-rng" ];
  };
}
