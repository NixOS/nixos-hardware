{
  lib,
  config,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    ../.
    ../../../common/cpu/intel/haswell
    ../../../common/pc/ssd
    "${modulesPath}/hardware/network/broadcom-43xx.nix"
  ];

  hardware.graphics.enable = lib.mkDefault true;
}
