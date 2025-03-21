{ lib, ... }:
{
  imports = [
    ../shared.nix
    ../../../../common/gpu/intel/comet-lake
    ../../../../common/gpu/nvidia/disable.nix # Disabling nvidia
  ];
}
