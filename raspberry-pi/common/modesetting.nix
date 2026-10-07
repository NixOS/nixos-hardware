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
    enable = lib.mkEnableOption "legacy FKMS on Raspberry Pi 2, 3, and 4";
    cma = lib.mkOption {
      type = lib.types.int;
      default = 512;
      description = "Contiguous memory allocation for FKMS, in MiB.";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
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
          FKMS is enabled alongside explicitly configured KMS overlays.
          Remove KMS overlays that match the same board as FKMS.
        '';
  };
}
