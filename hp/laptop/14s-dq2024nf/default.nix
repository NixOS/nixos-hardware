{ config, lib, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/gpu/intel/tiger-lake
    ../../../common/pc
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
  ];
}
