{ ... }:
{
  imports = [
    ./sensors.nix
    ./audio.nix
    ./power.nix

    ../../common/gpu/amd/default.nix
    ../../common/cpu/amd/default.nix
    ../../common/pc/laptop/default.nix
  ];
}
