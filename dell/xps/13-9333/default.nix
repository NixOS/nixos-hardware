{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  # Required to allow the touchpad to work
  boot.kernelParams = [ "i8042.nopnp=1" ];
  boot.blacklistedKernelModules = [
    "i2c_hid"
    "i2c_hid_acpi"
  ];
  boot.kernelModules = [ "synaptics_i2c" ];
}
