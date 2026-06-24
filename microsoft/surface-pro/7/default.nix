{
  imports = [ ../../surface/surface-pro-intel ];

  boot.initrd.kernelModules = [ "pinctrl_icelake" ];
}
