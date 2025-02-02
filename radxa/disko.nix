{ lib
, pkgs
, config
, ...
}:
let
  cfg = config.hardware.radxa;
in {
  imports = [
    ../rockchip/disko.nix
  ];
}
