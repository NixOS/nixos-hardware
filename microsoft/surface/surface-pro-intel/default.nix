{ lib, ... }:

let
  inherit (lib) mkDefault;
in {
  imports = [
    ../common
    ../../../common/pc
    ../../../common/pc/ssd
    ../../../common/cpu/intel
  ];

  microsoft-surface.ipts.enable = true;
  microsoft-surface.surface-control.enable = true;
}
