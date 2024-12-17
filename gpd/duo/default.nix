{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hardware.gpd.duo;
in
with lib;
{
  imports = [
    ./duo-specific
    ../../common/pc/laptop
    ../../common/pc/ssd
    ../../common/hidpi.nix
  ];

  options = {
    hardware.gpd.duo.preventWakeOnAC = mkOption {
      type = types.bool;
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
    # Workaround applied upstream in Linux >=6.7 (on BIOS 03.03)
    # https://github.com/torvalds/linux/commit/a55bdad5dfd1efd4ed9ffe518897a21ca8e4e193
    services.udev.extraRules =
      mkIf (versionOlder config.boot.kernelPackages.kernel.version "6.7" && cfg.preventWakeOnAC)
        ''
          # Prevent wake when plugging in AC during suspend. Trade-off: keyboard wake disabled. See:
          # https://community.frame.work/t/tracking-framework-amd-ryzen-7040-series-lid-wakeup-behavior-feedback/39128/45
          ACTION=="add", SUBSYSTEM=="serio", DRIVERS=="atkbd", ATTR{power/wakeup}="disabled"
        '';

    # Replace 'left' with 'right' or 'inverted' as needed
    # Fixes DUO stupid inverted display at boot
    # Enable kernel module for your graphics (adjust if needed)
    boot.kernelModules = [ "amdgpu" ];

    # Set the eDP-1 panel video parameters for display rotation
    boot.kernelParams = mkBefore [
      "video=eDP-1:2880x1800,panel_orientation=upside_down"
      "video=DP-3:2880x1800"
      "i2c_touchscreen_props=GXTP7380:touchscreen-inverted-x:touchscreen-inverted-y"
    ];

    hardware.gpd.duo.audioEnhancement.rawDeviceName =
      mkDefault "alsa_output.pci-0000_c1_00.6.analog-stereo";
  };
}
