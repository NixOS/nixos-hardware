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
  boot.initrd.kernelModules = [
    "pinctrl_tigerlake"
  ]
  # Additional modules for touchscreen/touchpad in initrd (for unl0kr on-screen keyboard)
  ++ lib.optionals config.boot.initrd.unl0kr.enable [
    "intel_lpss_pci"
    "i2c_hid_acpi"
    "i2c_hid"
    "hid_multitouch"
    "hid_generic"
  ];
}
