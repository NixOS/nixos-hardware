{ config, lib, ... }:
{
  imports = [
    ../common
    ../../../common/cpu/intel
  ];

  # Linux 7.1 includes BE213 WiFi support
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "7.1") (
    lib.mkDefault pkgs.linuxPackages_latest
  );

  # Enable fprintd and make commands available
  services.fprintd.enable = true;
  environment.systemPackages = with pkgs; [
    fprintd
  ];

  # If enable serial console in BIOS you can use this to get logs and log
  # into TTY through JECDB or the Type-C CCD connector
  # See github.com/frameworkComputer/FrameworkDebugger
  # boot.kernelParams = [
  #   "console=ttyS0,115200n8"
  #   "console=tty0"  # keeps display as primary /dev/console
  # ];

  # If this module isn't built into the kernel, we need to make sure it loads
  # before soc_button_array. Otherwise the tablet mode gpio doesn't work.
  # If correctly loaded, dmesg should show
  # input: gpio-keys as /devices/platform/INT33D3:00
  boot.initrd.kernelModules = [
    "pinctrl_intel_platform"
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
