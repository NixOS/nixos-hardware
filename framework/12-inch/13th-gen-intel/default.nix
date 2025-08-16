{ config, lib, ... }:
{
  imports = [
    ../common
    ../../../common/cpu/intel
  ];

  # If this module isn't built into the kernel, we need to make sure it loads
  # before soc_button_array. Otherwise the tablet mode gpio doesn't work.
  # If correctly loaded, dmesg should show
  # input: gpio-keys as /devices/platform/INT33D3:00
  boot.initrd.kernelModules = [ "pinctrl_tigerlake" ];
}
