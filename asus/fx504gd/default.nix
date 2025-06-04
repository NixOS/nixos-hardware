{ ... }:
{
  imports = [
    ../../common/cpu/intel
    ../../common/pc/laptop
  ];

  #Nouveau doesn't work at all on this model.
  boot.kernelParams = [ "nouveau.modeset=0" ];
}
