{ config, lib, pkgs, ... }:

let
  cfg = config.hardware.framework.amd-7040;
in
{
  imports = [
    ../common
    ../common/amd.nix
  ];

  options = {
    hardware.framework.amd-7040.preventWakeOnAC = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Stop the system waking from suspend when the AC is plugged
        in. The catch: it also disables waking from the keyboard.

        See:
        https://community.frame.work/t/tracking-framework-amd-ryzen-7040-series-lid-wakeup-behavior-feedback/39128/45
      '';
    };
  };

  config = {
    # Newer kernel is better for amdgpu driver updates
    # Requires at least 5.16 for working wi-fi and bluetooth (RZ616, kmod mt7922):
    # https://wireless.wiki.kernel.org/en/users/drivers/mediatek
    boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.1") (lib.mkDefault pkgs.linuxPackages_latest);

    services.udev.extraRules = lib.optionalString cfg.preventWakeOnAC ''
      # Prevent wake when plugging in AC during suspend. Trade-off: keyboard wake disabled. See:
      # https://community.frame.work/t/tracking-framework-amd-ryzen-7040-series-lid-wakeup-behavior-feedback/39128/45
      ACTION=="add", SUBSYSTEM=="serio", DRIVERS=="atkbd", ATTR{power/wakeup}="disabled"
    '';
  };
}
