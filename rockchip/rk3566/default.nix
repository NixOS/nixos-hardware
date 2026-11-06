{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.hardware.rockchip.rk3566;
in
{
  options.hardware.rockchip.rk3566 = {
    enable = lib.mkEnableOption "Rockchip RK3566 support";
  };

  config = lib.mkIf cfg.enable {
    hardware.rockchip.enable = true;
  };
}
