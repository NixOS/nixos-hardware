{ lib, pkgs, ... }:

{
  imports = [
    ../../common/cpu/intel/kaby-lake
    ../../common/gpu/nvidia/pascal
    ../../common/pc/laptop
    ../../common/pc/laptop/ssd
    ../../common/pc/laptop/hdd
  ];
}
