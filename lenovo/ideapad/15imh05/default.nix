{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel/comet-lake
    ../../../common/gpu/nvidia/turing
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];
}
