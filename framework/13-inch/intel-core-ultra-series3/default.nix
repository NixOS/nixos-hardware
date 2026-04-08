{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../common
    ../common/intel.nix
  ];

  # Everything is updateable through fwupd
  services.fwupd.enable = true;
}
