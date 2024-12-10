{ config, lib, ... }:
let
  cfg = config.hardware.orange-pi."5-max".audio;
in
{
  options.hardware = {
    orange-pi."5-max".audio = {
      enable = lib.mkEnableOption "audio device configuration" // {
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.pipewire.wireplumber.extraConfig = {
      "orange-pi-5-max-descriptions" = {
        "monitor.alsa.rules" =
          let
            makeRule = name: description: {
              matches = [{ "device.name" = name; }];
              actions = {
                update-props = {
                  "device.description" = description;
                };
              };
            };
          in
          [
            (makeRule "alsa_card.platform-hdmi0-sound" "HDMI0 Audio")
            (makeRule "alsa_card.platform-hdmi1-sound" "HDMI1 Audio")
            (makeRule "alsa_card.platform-es8388-sound" "ES8388 Audio")
          ];
      };
    };

    services.udev.extraRules = ''
      SUBSYSTEM=="sound", ENV{ID_PATH}=="platform-hdmi0-sound", ENV{SOUND_DESCRIPTION}="HDMI0 Audio"
      SUBSYSTEM=="sound", ENV{ID_PATH}=="platform-hdmi1-sound", ENV{SOUND_DESCRIPTION}="HDMI1 Audio"
      SUBSYSTEM=="sound", ENV{ID_PATH}=="platform-es8388-sound", ENV{SOUND_DESCRIPTION}="ES8388 Audio"
    '';
  };
}
