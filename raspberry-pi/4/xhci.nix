{
  config,
  lib,
  ...
}:
let
  cfg = config.hardware.raspberry-pi."4".xhci;
in
{
  options.hardware = {
    raspberry-pi."4".xhci = {
      enable = lib.mkEnableOption ''
        Enable builtin XHCI controller for USB with otg_mode=1 in config.txt
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.deviceTree = {
      overlays = [
        {
          name = "enable-xhci";
          dtsText = ''
            /dts-v1/;
            /plugin/;

            / {
              compatible = "brcm,bcm2711";
              fragment@0 {
                //target-path = "/scb/xhci@7e9c0000";
                target = <&xhci>;
                __overlay__ {
                  status = "okay";
                };
              };
            };
          '';
        }
      ];
    };
  };
}
