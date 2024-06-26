{ config,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf mkMerge;
  cfg = config.hardware.asus.zephyrus.ga402x;

in {
  imports = [
    ../shared.nix
  ];

  options.hardware.asus.zephyrus.ga402x.amdgpu = {
    recovery.enable = (mkEnableOption "Enable amdgpu.gpu_recovery kernel boot param") // { default = false; };
    sg_display.enable = (mkEnableOption "Enable amdgpu.gpu_recovery kernel boot param") // { default = true; };
    psr.enable = (mkEnableOption "Enable amdgpu.dcdebugmask=0x10 kernel boot param") // { default = true; };
  };

  config = mkMerge [
    (mkIf cfg.amdgpu.recovery.enable {
      # Hopefully fixes for where the kernel sometimes hangs when suspending or hibernating
      #  (Though, I'm very suspicious of the Mediatek Wifi...)
      boot.kernelParams = [
        "amdgpu.gpu_recovery=1"
      ];
    })

    (mkIf (!cfg.amdgpu.sg_display.enable) {
      # Can help solve flickering/glitching display issues since Scatter/Gather code was reenabled
      boot.kernelParams = [
        "amdgpu.sg_display=0"
      ];
    })

    (mkIf (!cfg.amdgpu.psr.enable) {
      # Can help solve flickering/glitching display issues since Scatter/Gather code was reenabled
      boot.kernelParams = [
        "amdgpu.dcdebugmask=0x10"
      ];
    })
  ];
}
