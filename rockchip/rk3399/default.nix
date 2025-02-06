{ lib
, pkgs
, config
, ...
}:
let
  cfg = config.hardware.rockchip.rk3399;
in {
  imports = [
    ../.
  ];

  options.hardware.rockchip.rk3399 = {
      enable = lib.mkEnableOption "Rockchip RK3399 support";
  };

  config = lib.mkIf cfg.enable {
    hardware.rockchip.enable = true;
  };
}
