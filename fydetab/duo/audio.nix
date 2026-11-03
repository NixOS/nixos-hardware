{
  lib,
  pkgs,
  ...
}:
let
  amixer = "${lib.getExe' pkgs.alsa-utils "amixer"} -c rockchipes8388";
in
{
  # The ES8388 output paths are off at boot. Without them the DAPM path is not complete,
  # and the card driver never turns on the speaker or headphone amplifier.
  systemd.services.fydetab-es8388-routing = {
    description = "FydeTab Duo ES8388 playback routing";
    after = [ "sound.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      for _ in $(seq 30); do
        ${amixer} info >/dev/null 2>&1 && break
        sleep 1
      done

      ${amixer} sset 'Left Mixer Left' on
      ${amixer} sset 'Right Mixer Right' on
      ${amixer} sset 'OUT1' on
      ${amixer} sset 'OUT2' on
    '';
  };
}
