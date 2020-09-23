{ config, lib, pkgs, ... }:

{
  imports = [
    ../.
    ../../../common/cpu/intel/kaby-lake
  ];

  # see https://github.com/NixOS/nixpkgs/issues/69289
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
