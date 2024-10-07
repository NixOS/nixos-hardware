{ config, lib, pkgs, ... }:

{
  imports = [
    ../.
  ];

  boot.extraModulePackages = lib.mkDefault [ config.boot.kernelPackages.broadcom_sta ];
}
