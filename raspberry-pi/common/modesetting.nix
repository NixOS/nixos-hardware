{
  config,
  lib,
  options,
  ...
}:

let
  cfg = config.hardware.raspberry-pi.fkms-3d;

  # Hexadecimal board-type IDs and model filters covered by [pi2], [pi3] or [pi4].
  # https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#raspberry-pi-revision-codes
  fkmsModels = {
    "4" = "pi2";
    "8" = "pi3";
    "a" = "cm3";
    "d" = "pi3+";
    "e" = "pi3+";
    "10" = "cm3+";
    "11" = "pi4";
    "13" = "pi400";
    "14" = "cm4";
    "15" = "cm4s";
  };
  hasKmsConflict =
    filters: overlays:
    let
      # config-txt.nix sorts the filters. The last model filter replaces earlier ones.
      matchesBoard =
        matches: filter:
        if lib.hasPrefix "board-type=" filter then
          lib.any (
            hex:
            builtins.match "board-type=(0x0*${hex}|${toString (lib.fromHexString hex)})" (lib.toLower filter)
            != null
          ) (lib.attrNames fkmsModels)
        else if builtins.match "(pi|cm)[0-9].*" filter != null then
          lib.elem filter (lib.attrValues fkmsModels)
        else
          matches;
    in
    !(lib.elem "none" filters)
    && lib.foldl' matchesBoard true (lib.sort builtins.lessThan filters)
    && lib.any (overlay: lib.any (lib.hasPrefix "vc4-kms-v3d") (lib.attrNames overlay)) overlays;

  # Removing the built-in KMS default does not remove user-supplied overlays.
  hasManualKms = lib.pipe config.hardware.raspberry-pi.configtxt.deviceTreeOverlays [
    (lib.mapAttrsToListRecursive hasKmsConflict)
    (lib.any lib.id)
  ];
in
{
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
    assertions = [
      {
        assertion = config.hardware.deviceTree.overlays == [ ];
        message = ''
          hardware.raspberry-pi.fkms-3d.enable uses the firmware-provided device tree.
          Move hardware.deviceTree.overlays to hardware.raspberry-pi.configtxt.deviceTreeOverlays before enabling FKMS.
        '';
      }
      {
        assertion = !config.boot.loader.generic-extlinux-compatible.useGenerationDeviceTree;
        message = ''
          hardware.raspberry-pi.fkms-3d.enable requires
          boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false.
          Remove the conflicting override so U-Boot keeps the firmware's FKMS overlay.
        '';
      }
      {
        assertion = config.hardware.raspberry-pi.firmware.enable || (options ? sdImage);
        message = ''
          Outside SD-image builds, hardware.raspberry-pi.fkms-3d.enable requires
          hardware.raspberry-pi.firmware.enable = true to install the firmware configuration.
          See "Firmware install" in raspberry-pi/README.md.
        '';
      }
    ];

    # Omit FDT/FDTDIR so U-Boot keeps the firmware's FKMS overlay.
    boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = lib.mkDefault false;
    # KUnit's VC4 tests crashed on older kernels (raspberrypi/linux#5568).
    boot.kernelParams = [ "kunit.enable=0" ];
    services.xserver.videoDrivers = lib.mkBefore [
      "modesetting"
      "fbdev"
    ];
    hardware.raspberry-pi = {
      configtxt = {
        settings = lib.genAttrs [ "pi2" "pi3" "pi4" ] (_: {
          display_auto_detect = false;
        });
        deviceTreeOverlays = lib.genAttrs [ "pi2" "pi3" "pi4" ] (_: [
          { vc4-fkms-v3d.cma-size = cfg.cma * 1048576; }
        ]);
      };
    };

    warnings = lib.optional hasManualKms ''
      A manually configured KMS overlay can apply to a board with FKMS enabled.
      Remove the KMS overlay or restrict its filters to other boards.
    '';
  };
}
