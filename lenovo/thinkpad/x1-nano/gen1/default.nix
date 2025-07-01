{ pkgs, ... }:

{
  imports = [ ../. ];

  environment.systemPackages = with pkgs; [
    alsa-utils
  ];

  systemd.services.x1-fix = {
    description = "Use alsa-utils to fix sound interference on Thinkpad x1 Nano";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.alsa-tools}/bin/hda-verb /dev/snd/hwC0D0 0x1d SET_PIN_WIDGET_CONTROL 0x0";
      Restart = "on-failure";
    };
    wantedBy = [ "default.target" ];
  };
}
