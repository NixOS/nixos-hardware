{ config, lib, ... }:

let
  cfg = config.hardware.raspberry-pi.dwc2;
in
{
  imports = [ ./config-txt.nix ];

  options.hardware.raspberry-pi.dwc2 = {
    enable = lib.mkEnableOption "the DWC2 USB controller through the firmware";
    dr_mode = lib.mkOption {
      type = lib.types.enum [
        "host"
        "peripheral"
        "otg"
      ];
      default = "otg";
      description = ''
        USB role for the DWC2 controller.
        The available connector depends on the board.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
    hardware.raspberry-pi.configtxt = {
      settings.cm4.otg_mode = null;
      deviceTreeOverlays = lib.genAttrs [ "pi2" "pi3" "pi4" "pi5" ] (_: [
        { dwc2.dr_mode = cfg.dr_mode; }
      ]);
    };

    assertions = [
      {
        assertion =
          lib.all
            (
              section:
              !(lib.elem (config.hardware.raspberry-pi.configtxt.settings.${section}.otg_mode or null) [
                true
                1
                "1"
              ])
            )
            [
              "all"
              "pi4"
              "pi5"
              "cm4"
              "cm5"
            ];
        message = ''
          DWC2 is enabled, but an otg_mode setting selects XHCI.
          Remove matching otg_mode settings from hardware.raspberry-pi.configtxt.settings.
        '';
      }
    ];
  };
}
