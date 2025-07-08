{ config, ... }:

{
  imports = [
    ../../common/cpu/intel
    ../../common/pc/laptop
    ../../common/pc/ssd
  ];

  # OneNetbook 4 has `GXTP7386:00 27C6:011A Stylus` exporting no buttons in 5.12
  # and libinput does't consider it a tablet without them, but a touchscreen.
  # This leads to real weird effects,
  # starting from clicking as soon as the pen gets tracked.
  # A kernel patch exists to resolve that, compiled as an out-of-tree module here
  # to avoid recompiling the kernel for such a small change.
  # `hid-multitouch-onenetbook4` is the fixed one, don't use `hid-multitouch`.
  boot.blacklistedKernelModules = [ "hid-multitouch" ];
  boot.extraModulePackages = [
    (config.boot.kernelPackages.callPackage ./goodix-stylus-mastykin { })
  ];

  # OneNetbook 4 has an accelerometer,
  hardware.sensor.iio.enable = true;
  # said accelerometer needs rotation, rotation needs iio-sensor-proxy >= 3.0
  services.udev.extraHwdb = ''
    acpi:BOSC0200:BOSC0200:*
     ACCEL_MOUNT_MATRIX=0, 1, 0; 0, 0, 1; 1, 0, 0
  '';
  # (this at least gets normal/left-up/right-up/bottom-up right)
}
