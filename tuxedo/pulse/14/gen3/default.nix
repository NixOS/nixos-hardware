{pkgs, ...}: {
  imports = [
    ../../../../common/cpu/amd
    ../../../../common/cpu/amd/pstate.nix
    ../../../../common/cpu/amd/raphael/igpu.nix
    ../../../../common/pc/laptop
    ../../../../common/pc/laptop/ssd
  ];
}
