{ config, lib, ... }:

{
  imports = [ 
    ../../.
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  # Built-in iSight is recognized by the generic uvcvideo kernel module
  hardware.facetimehd.enable = false;
}
