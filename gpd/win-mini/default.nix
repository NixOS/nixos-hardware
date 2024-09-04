{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.hardware.gpd.ppt;
in
{
  imports = [
    ../../common/pc/laptop
    ../../common/pc/ssd
    ../../common/hidpi.nix
  ];
}
