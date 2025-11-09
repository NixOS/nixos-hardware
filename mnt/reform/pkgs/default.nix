{
  lib,
  callPackage,
}:
rec {
  reform-flash-uboot =
    lib.mapAttrs (_name: config: callPackage ./reform-flash-uboot.nix { inherit config; })
      {
        reform2-rk3588-dsi = {
          warn = true;
          mmc = "mmcblk0";
          mmcBoot0 = false;
          ubootOffset = 32768;
          flashbinOffset = 0;
          image = "${ubootImage.reform2-rk3588-dsi}/rk3588-mnt-reform2-dsi-flash.bin";
        };
      };

  uboot.reform2-rk3588-dsi = callPackage ../rk3588/uboot.nix { };
  ubootImage.reform2-rk3588-dsi = callPackage ../rk3588/uboot-image.nix {
    uboot = uboot.reform2-rk3588-dsi;
  };
}
