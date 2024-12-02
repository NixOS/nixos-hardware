{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
  ];

  # Force S3 sleep mode. See README.wiki for details.
  boot.kernelParams = [ "mem_sleep_default=deep" ];

  # touchpad goes over i2c
  boot.blacklistedKernelModules = [ "psmouse" ];

  # Allows for updating firmware via `fwupdmgr`.
  services.fwupd.enable = true;

  # This will save you money and possibly your life!
  services.thermald.enable = true;
}
