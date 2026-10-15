{ config, lib, ... }:

let
  cfg = config.hardware.raspberry-pi.fkms-3d;
  overlays = lib.concatLists (
    lib.collect builtins.isList config.hardware.raspberry-pi.configtxt.deviceTreeOverlays
  );
in
{
  imports = [
    ./audio.nix
    ./config-txt.nix
  ];

  options.hardware.raspberry-pi.fkms-3d = {
    enable =
      lib.mkEnableOption "firmware-assisted display control (FKMS) on Raspberry Pi 2, 3, and 4"
      // {
        description = ''
          Enable firmware-assisted display control (FKMS) on Raspberry Pi 2, 3, and 4.
          Leave this disabled to use KMS, which lets the kernel control the display.
        '';
      };
    cma = lib.mkOption {
      type = lib.types.int;
      default = 512;
      description = "Contiguous memory allocation for FKMS, in MiB.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Omit FDT/FDTDIR so U-Boot keeps the firmware's FKMS overlay.
    boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
    # KUnit's VC4 tests crashed on older kernels (raspberrypi/linux#5568).
    boot.kernelParams = [ "kunit.enable=0" ];
    services.xserver.videoDrivers = lib.mkBefore [
      "modesetting"
      "fbdev"
    ];
    hardware.raspberry-pi = {
      audio.hdmi.enable = lib.mkDefault true;
      configtxt = {
        settings = lib.genAttrs [ "pi2" "pi3" "pi4" ] (_: {
          display_auto_detect = false;
        });
        deviceTreeOverlays = lib.genAttrs [ "pi2" "pi3" "pi4" ] (_: [
          { vc4-fkms-v3d.cma-size = cfg.cma * 1048576; }
        ]);
      };
    };

    warnings =
      lib.optional
        (lib.any (overlay: lib.any (lib.hasPrefix "vc4-kms-v3d") (lib.attrNames overlay)) overlays)
        ''
          FKMS is enabled alongside manually configured KMS overlays.
          Remove KMS overlays that match the same board as FKMS.
        '';
  };
}
