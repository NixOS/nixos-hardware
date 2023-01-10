{ lib, ... }:

let
  inherit (lib) mkDefault;
in {
  imports = [
    ../common
  ];

  microsoft-surface.ipts.enable = true;
  microsoft-surface.surface-control.enable = true;
}
