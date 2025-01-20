{ lib
, pkgs
, config
, ...
}:
let
  cfg = config.hardware.rockchip;
in {
  options.hardware.rockchip = {
    enable = lib.mkEnableOption "Rockchip SoC support";
    diskoImageName = lib.mkOption {
      type = lib.types.str;
      default = "main.raw";
      description = ''
        The output image name for Disko.
        Can be used by diskoExtraPostVM.
      '';
    };
    diskoExtraPostVM = lib.mkOption {
      type = lib.types.str;
      description = ''
        The post VM hook for Disko's Image Builder.
        Can be used to install platform firmware like U-Boot.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      kernelParams = [ "console=ttyS2,1500000n8" ];
    };
  };
}
