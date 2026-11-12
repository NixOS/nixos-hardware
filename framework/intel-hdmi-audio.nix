{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.hardware.framework.sof = {
    enable =
      (lib.mkEnableOption "the SOF firmware for streaming audio to external devices via HDMI on Intel Framework devices")
      // {
        # Seems to affect most Intel framework devices
        # https://community.frame.work/t/resolved-no-hdmi-audio-out-devices-available/34996
        # https://community.frame.work/t/resolved-no-audio-via-hdmi/39823
        # https://community.frame.work/t/solved-hdmi-audio-issues-with-fedora-44/82549
        default = true;
      };
    driver = lib.mkOption {
      description = "Which DSP driver to use. `1` is the HDA driver, `2` is the SST driver, and `3` is the SOF driver.";
      type = lib.types.enum [
        1
        2
        3
      ];
      default = 1; # Seems to provide the most sensible device names.
      example = 3;
    };
  };

  config = lib.mkIf config.hardware.framework.sof.enable {
    hardware.firmware = [ pkgs.sof-firmware ];
    boot.extraModprobeConfig = ''
      options snd-intel-dspcfg dsp_driver=${toString config.hardware.framework.sof.driver}
    '';
  };
}
