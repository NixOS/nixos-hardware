{ config, lib, pkgs, ... }: let

  inherit (lib) types;

in {
  imports = [
    ../../common/pc/laptop
    ../../common/pc/laptop/acpi_call.nix
    ../../common/cpu/intel
  ];

  options.hardware.battery.powersave = lib.mkOption {
    type = types.bool;
    default = false;
    description = ''
      Enable some battery saving services.

      See also `hardware.cpu.intel.max-frequency` in common/cpu/intel module,
      which can be used to reduce power usage by CPU to minimum.
    '';
  };

  options.hardware.battery.optimize = lib.mkOption {
    type = types.enum [ "mostly-pluggedin" "lifetime" "runtime" ];
    default = "runtime";
    description = ''
      Set battery charging parameters:
      - runtime: always charge to maximum capacity
      - lifetime: stop charging at 80% capacity, to increase battery lifetime
      - mostly-pluggedin: stop charging at 50% capacity, useful for laptops
        with mostly plugged-in AC cable.

      In case full battery charge is needed, use `tlp fullcharge`
      to remove thresholds temporarily.

      Based on https://linrunner.de/en/tlp/docs/tlp-faq.html#battery
    '';
  };

  options.hardware.fingerprint.enable = lib.mkOption {
    type = types.bool;
    default = false;
    description = ''
      Enables fingerprint reader device (available on some ThinkPads).

      To login and unlock with fingerprint, enroll first with `fprintd-enroll`.
    '';
  };

  config = lib.mkMerge [

    (lib.mkIf (config.hardware.battery.powersave
        || config.hardware.battery.optimize != "runtime") {
      environment.systemPackages = [ pkgs.tlp ];
      services.tlp.enable = true;
    })

    (lib.mkIf config.hardware.battery.powersave {
      powerManagement.powertop.enable = true;

      services.tlp.extraConfig = ''
        CPU_SCALING_GOVERNOR_ON_BAT=powersave
        ENERGY_PERF_POLICY_ON_BAT=powersave
      '';
    })

    (lib.mkIf (config.hardware.battery.optimize == "lifetime") {
      services.tlp.extraConfig = ''
        START_CHARGE_THRESH_BAT0=75
        STOP_CHARGE_THRESH_BAT0=80
      '';
    })

    (lib.mkIf (config.hardware.battery.optimize == "mostly-pluggedin") {
      services.tlp.extraConfig = ''
        START_CHARGE_THRESH_BAT0=40
        STOP_CHARGE_THRESH_BAT0=50
      '';
    })

    {
      services.fprintd.enable = lib.mkDefault config.hardware.fingerprint.enable;

      hardware.trackpoint.enable = lib.mkDefault true;
    }
  ];
}