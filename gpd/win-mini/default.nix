{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  imports = [
    ../../common/pc/laptop
    ../../common/pc/ssd
    ../../common/hidpi.nix
  ];
}
