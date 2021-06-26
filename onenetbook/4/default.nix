{ pkgs, config, lib, ... }:

let
  iio-sensor-proxy-supports-rotation =
    lib.versionAtLeast pkgs.iio-sensor-proxy.version "3.0";
in
{
  imports = [
    ../../common/cpu/intel
    ../../common/pc/laptop
    ../../common/pc/laptop/ssd
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
    (config.boot.kernelPackages.callPackage ./goodix-stylus-mastykin {})
  ];

  # OneNetbook 4 has an accelerometer,
  hardware.sensor.iio.enable = lib.mkDefault iio-sensor-proxy-supports-rotation;
  # said accelerometer needs rotation, rotation needs iio-sensor-proxy >= 3.0
  services.udev.extraHwdb = lib.mkIf iio-sensor-proxy-supports-rotation ''
    acpi:BOSC0200:BOSC0200:*
     ACCEL_MOUNT_MATRIX=0, 1, 0; 0, 0, 1; 1, 0, 0
  '';
  # (this at least gets normal/left-up/right-up/bottom-up right)
  # Until https://github.com/NixOS/nixpkgs/pull/125989 reaches you, you can use
  #nixpkgs.overlays = [
  #  (self: super: {
  #    iio-sensor-proxy =
  #      if (lib.versionOlder super.iio-sensor-proxy.version "3.0") then
  #        (super.iio-sensor-proxy.overrideAttrs (oa: rec {
  #          version = "3.0";
  #          src = pkgs.fetchFromGitLab {
  #            domain = "gitlab.freedesktop.org";
  #            owner = "hadess";
  #            repo = "iio-sensor-proxy";
  #            rev = version;
  #            sha256 = "0ngbz1vkbjci3ml6p47jh6c6caipvbkm8mxrc8ayr6vc2p9l1g49";
  #          };
  #        }))
  #      else super.iio-sensor-proxy;
  #  })
  #];
}
