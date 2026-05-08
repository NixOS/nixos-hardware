{
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkDefault;
in
{

  imports = [
    ../../../common/cpu/amd
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/amd
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    kernelModules = [ "kvm-amd" ];
    kernelParams = [
      "pcie_aspm.policy=powersupersave"
      # 0xc10 = DC_DISABLE_PSR | DC_DISABLE_REPLAY | DC_DISABLE_IPS.
      # this works around suspend/resume stability issues and rendering glitches (stuck frames)
      "amdgpu.dcdebugmask=0xc10"
    ];
  };

  services = {
    asusd.enable = mkDefault true;

    # services.asusd enables supergfxd, and we only have one gpu
    supergfxd.enable = false;

    udev.extraHwdb = ''
      # Fixes mic mute button
      evdev:name:*:dmi:bvn*:bvr*:bd*:svnASUS*:pn*:*
      KEYBOARD_KEY_ff31007c=f20
    '';
  };

  # for screen auto-rotate
  hardware.sensor.iio.enable = mkDefault true;
}
