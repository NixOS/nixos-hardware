{
  config,
  lib,
  pkgs,
  ...
}:
{
  config =
    lib.mkIf config.hardware.librem5.audio {
      services.dbus.packages = [ pkgs.callaudiod ];
    }
    // (
      let
        paConfig = {
          enable = true;
          # this is required to correctly configure the modem as PA source/sink
          extraConfig = ''
            .include ${config.hardware.librem5.package}/etc/pulse/librem5.pa
          '';
        };
      in
      {
        assertions = [
          {
            assertion = config.services.pulseaudio.enable;
            message = "Call audio on Librem5 requires pulse audio to be enabled through `services.pulseaudio.enable`.";
          }
        ];
        services.pulseaudio = paConfig;
      }
    );
}
