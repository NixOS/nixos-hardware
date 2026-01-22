{ ... }:
{
  imports = [
    ../../common/pc/laptop
    ../../common/pc/ssd
  ];

  # Needed to have the keyboard working during the initrd sequence
  boot.initrd.availableKernelModules = [ "battery" ];

}
