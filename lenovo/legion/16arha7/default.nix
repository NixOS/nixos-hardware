{ config, pkgs, ... }:

let
  lenovo-speaker-fix = pkgs.callPackage ./audio/lenovo-16ARHA7_speaker-fix.nix {
    # Make sure the module targets the same kernel as your system is using.
    inherit (config.boot.kernelPackages) kernel;
  };
in
{
  imports = [
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/amd
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
  ];

  boot.extraModulePackages = [ lenovo-speaker-fix ];
  
  # √(2560² + 1600²) px / 16 in ≃ 189 dpi
  services.xserver.dpi = 189;

  # Enable fingerprint reader
  services.fprintd = {
    enable = true;
    package = pkgs.fprintd-tod;
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-elan;
    };
  };
}
