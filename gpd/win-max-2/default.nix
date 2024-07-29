{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.hardware.gpd.ppt;
in
{
  imports = [
    ../../common/pc/laptop
    ../../common/pc/ssd
    ../../common/hidpi.nix
  ];

  # Linux default PPT is 24-22-22, BIOS default PPT is 35-32-28. It can be controlled by ryzenadj.

  # NOTICE: Whenever you can limit PPT to 15W by pressing Fn + Shift to enter quiet mode.

  options.hardware.gpd.ppt = {
    enable = mkEnableOption "Enable PPT control for device by ryzenadj." // {
      # Default increase PPT to the BIOS default when power adapter plugin to increase performance.
      default = true;
    };

    adapter = {
      fast-limit = mkOption {
        description = "Fast PTT Limit(milliwatt) when power adapter plugin.";
        default = 35000;
        type = types.ints.unsigned;
      };
      slow-limit = mkOption {
        description = "Slow PTT Limit(milliwatt) when power adapter plugin.";
        default = 32000;
        type = types.ints.unsigned;
      };
      stapm-limit = mkOption {
        description = "Stapm PTT Limit(milliwatt) when power adapter plugin.";
        default = 28000;
        type = types.ints.unsigned;
      };
    };

    battery = {
      fast-limit = mkOption {
        description = "Fast PTT Limit(milliwatt) when using battery.";
        default = 24000;
        type = types.ints.unsigned;
      };
      slow-limit = mkOption {
        description = "Slow PTT Limit(milliwatt) when using battery.";
        default = 22000;
        type = types.ints.unsigned;
      };
      stapm-limit = mkOption {
        description = "Stapm PTT Limit(milliwatt) when using battery.";
        default = 22000;
        type = types.ints.unsigned;
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.ryzenadj ];
    services.udev.extraRules = ''
      SUBSYSTEM=="power_supply", KERNEL=="ADP1", ATTR{online}=="1", RUN+="${pkgs.ryzenadj}/bin/ryzenadj --stapm-limit ${toString cfg.adapter.stapm-limit} --fast-limit ${toString cfg.adapter.fast-limit} --slow-limit ${toString cfg.adapter.slow-limit}"
      SUBSYSTEM=="power_supply", KERNEL=="ADP1", ATTR{online}=="0", RUN+="${pkgs.ryzenadj}/bin/ryzenadj --stapm-limit ${toString cfg.battery.stapm-limit} --fast-limit ${toString cfg.battery.fast-limit} --slow-limit ${toString cfg.battery.slow-limit}"
    '';
  };
}
