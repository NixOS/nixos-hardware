{
  imports = [ ../../surface-pro-intel ];

  boot.initrd.kernelModules = [ "pinctrl_sunrisepoint" ]; # Ensures that the volume buttons work every boot
}
