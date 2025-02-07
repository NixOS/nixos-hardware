{ lib
, pkgs
, config
, ...
}:
let
  cfg = config.hardware.rockchip.rk3328;
in {
  options.hardware.rockchip.rk3328 = {
    enable = lib.mkEnableOption "Rockchip RK3328 support";
  };

  config = lib.mkIf cfg.enable {
    hardware.rockchip.enable = true;
  };
}
