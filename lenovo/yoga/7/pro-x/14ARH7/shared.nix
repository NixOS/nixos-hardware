{
  imports = [
    ../shared
    ../../../../../common/cpu/amd
    # Better power-savings from AMD PState
    ../../../../../common/cpu/amd/pstate.nix
    ../../../../../common/gpu/amd
  ];

  boot.kernelModules = [ "kvm-amd" ];
}
