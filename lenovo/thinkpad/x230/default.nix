{ lib, ... }:

{
  imports = [
    ../.
    ../../../common/cpu/intel
    ../../../common/pc/laptop
  ];

  boot = {
    kernelModules = [
      "tpm-rng"
    ];
  };

  services.xserver.deviceSection = lib.mkDefault ''
    Option "TearFree" "true"
  '';
}
