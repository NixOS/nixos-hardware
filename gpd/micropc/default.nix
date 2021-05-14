{ ... }:
{
  imports = [
    ../../common/pc/laptop
    ../../common/pc/laptop/ssd
  ];

  # Needed to have the keyboard working during the initrd sequence
  boot.initrd.availableKernelModules = [ "battery" ];

}
