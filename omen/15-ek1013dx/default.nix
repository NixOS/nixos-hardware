{ lib, pkgs, ... }:

{
  imports = [
    ../../common/cpu/intel/comet-lake
    ../../common/gpu/nvidia/ampere
    ../../common/pc/laptop
    ../../common/pc/laptop/ssd
    ../../common/pc/laptop/hdd
  ];

  boot.kernelModules = [ "hp-wmi" ];
}