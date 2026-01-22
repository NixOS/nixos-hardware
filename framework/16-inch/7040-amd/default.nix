{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../common
    ../common/amd.nix
    ../../../common/cpu/amd/raphael/igpu.nix
  ];

  # Everything is updateable through fwupd
  services.fwupd.enable = true;
}
