{ lib
, pkgs
, config
, ...
}:
let
  cfg = config.hardware.rockchip.rk3588;
in {
  options.hardware.rockchip.rk3588 = {
    enable = lib.mkEnableOption "Rockchip RK3588 support";
  };

  config = lib.mkIf cfg.enable {
    hardware.rockchip.enable = true;
  };
}
