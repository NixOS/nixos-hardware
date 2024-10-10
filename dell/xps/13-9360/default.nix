{
  imports = [
    ../../../common/cpu/intel/kaby-lake
    ../../../common/pc/laptop
  ];

  boot.blacklistedKernelModules = [ "psmouse" ]; # touchpad goes over i2c

  # This will save you money and possibly your life!
  services.thermald.enable = true;
}
