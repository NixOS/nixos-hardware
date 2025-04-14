{ config, pkgs, lib, ... }:
let
  cfg = config.hardware.orange-pi."5-max".graphics;
  mali-firmware = pkgs.callPackage ./mali-firmware.nix { };
in
{
  options.hardware = {
    orange-pi."5-max".graphics = {
      enable = lib.mkEnableOption "gpu configuration" // {
        default = config.hardware.graphics.enable;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    hardware = {
      deviceTree = {
        overlays = [
          {
            name = "rockchip-rk3588-panthor-gpu";
            dtsText = ''
              /dts-v1/;
              /plugin/;
              / {
                compatible = "rockchip,rk3588";
              };
              / {
                fragment@0 {
                  target = <&gpu>;
                  __overlay__ {
                    status = "disabled";
                  };
                };
                fragment@1 {
                  target = <&gpu_panthor>;
                  __overlay__ {
                    status = "okay";
                    mali-supply = <&vdd_gpu_s0>;
                  };
                };
              };
            '';
          }
        ];
      };

      firmware = [
        mali-firmware
      ];
    };
  };
}
