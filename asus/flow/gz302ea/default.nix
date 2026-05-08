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
    # kernel >7.2-rc1 where ism was rewritten
    kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "7.2") pkgs.linuxPackages_testing;
    kernelModules = [ "kvm-amd" ];
    kernelParams = [
      "pcie_aspm.policy=powersupersave"
      "amdgpu.dcdebugmask=0x410" # 0x10 = disable PSR, 0x400 = disable panel replay
    ];
  };

  # linux-firmware pinned past the 20260622 release for the DMCUB
  # 0.1.65.0 update (e3e36153, 2026-06-26, includes dcn_3_5_1)
  nixpkgs.overlays = [
    (final: prev: {
      linux-firmware =
        if lib.versionOlder prev.linux-firmware.version "20260626" then
          prev.linux-firmware.overrideAttrs {
            version = "20260622-unstable-2026-06-26";
            src = final.fetchFromGitLab {
              owner = "kernel-firmware";
              repo = "linux-firmware";
              rev = "e3e36153ce3fff3f9c063dec7c267ce676a00a50";
              hash = "sha256-XtTS975qrdABk0xCnisBgCEGvCIRzkoupsimXXGSuBQ=";
            };
          }
        else
          prev.linux-firmware;
    })
  ];

  hardware.bluetooth.enable = mkDefault true;

  services = {
    asusd.enable = mkDefault true;

    # services.asusd enables supergfxd, and we only have one gpu
    supergfxd.enable = false;

    udev.extraRules = ''
      # The GZ302EA folio touchpad is USB-attached, so systemd's input_id builtin
      # tags it as an *external* touchpad and libinput then hides "disable while
      # typing" support. Force the touchpad to be internal.
      ACTION=="add|change", SUBSYSTEM=="input", KERNEL=="event*", ENV{ID_INPUT_TOUCHPAD}=="1", ENV{ID_VENDOR_ID}=="0b05", ENV{ID_MODEL_ID}=="1a30", ENV{ID_INPUT_TOUCHPAD_INTEGRATION}="internal"
    '';
  };

  # for screen auto-rotate
  hardware.sensor.iio.enable = mkDefault true;
}
