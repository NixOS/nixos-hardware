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
    kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "7.2") pkgs.linuxPackages_latest;
    kernelModules = [ "kvm-amd" ];
    kernelParams = [
      "pcie_aspm.policy=powersupersave"
    ];
  };

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
