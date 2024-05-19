{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.hardware.librem5.audio {
    assertions = [{
      assertion = config.hardware.pulseaudio.enable;
      message = "Call audio on Librem5 requires pulse audio to be enabled through `hardware.pulseaudio.enable`.";
    }];
    hardware.pulseaudio = {
      enable = true;
      # this is required to correctly configure the modem as PA source/sink
      extraConfig = ''
        .include ${config.hardware.librem5.package}/etc/pulse/librem5.pa
      '';
    };

    services.dbus.packages = [ pkgs.callaudiod ];
  };
}
