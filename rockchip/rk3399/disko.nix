{ lib
, pkgs
, config
, ...
}:
let
  cfg = config.hardware.rockchip.rk3399;
in {
  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "arm-trusted-firmware-rk3399"
    ];
  };
}
