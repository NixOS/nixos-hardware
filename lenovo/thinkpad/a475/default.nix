{ ... }:
{
  imports = [
    ../../../common/gpu/amd
    ../../../common/cpu/amd
    ../../../common/cpu/amd/pstate.nix
    ../../../common/pc/ssd
    ../../../common/pc/laptop/hdd
    #../../../common/hidpi.nix                #hidpi
    ../.
  ];

  boot.kernelParams = [ "i8042.nomux=1" "i8042.reset" ]; # Fix trackpoint and touchpad working only after reboot
}

