{ lib, ... }:

{
  imports = [
    (lib.mkRemovedOptionModule
      [
        "hardware"
        "raspberry-pi"
        "4"
        "fkms-3d"
      ]
      ''
        For legacy FKMS, use the vc4-fkms-v3d firmware overlay:

          { lib, ... }:

          {
            boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
            hardware.raspberry-pi.configtxt = {
              settings.pi4.display_auto_detect = false;
              deviceTreeOverlays.all = [ ];
              deviceTreeOverlays.pi4 = [
                { vc4-fkms-v3d.cma-size = 536870912; }
              ];
            };
            boot.kernelParams = [ "kunit.enable=0" ];
            services.xserver.videoDrivers = lib.mkBefore [ "modesetting" "fbdev" ];
          }

        cma-size uses bytes. Multiply the previous cma value in MiB by 1048576.
        The example preserves the old 512 MiB allocation, X11 driver order,
        and KUnit workaround.

        The empty all list removes the profile's default KMS overlay.
        Remove any explicitly configured KMS overlays too. Do not load KMS
        and FKMS together.

        For the default KMS configuration, remove the old fkms-3d option
        without adding this legacy configuration.
        For firmware installation, read "Device tree overlays" in
        raspberry-pi/README.md.
      ''
    )
  ];
}
