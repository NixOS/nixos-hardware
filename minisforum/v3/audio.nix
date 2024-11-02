{ ... }:
{
  # Fix microphone.
  # Based on https://github.com/mudkipme/awesome-minisforum-v3/issues/10#issuecomment-2317474057 (Volume control workaround doesn't work on Arch) 
  boot.extraModprobeConfig = ''
    options snd-hda-intel model=alc256-asus-aio
  '';

  # Based on https://github.com/mudkipme/awesome-minisforum-v3/issues/9#issue-2407782714 (volume control fixes for arch)
  services.pipewire.wireplumber.extraConfig."alsa-soft-mixer"."monitor.alsa.rules" = [
    {
      # Enable soft-mixer.
      # Fix global volume control.
      actions.update-props."api.alsa.soft-mixer" = true;
      matches = [
        {
          "device.name" = "~alsa_card.*";
        }
      ];
    }
    {
      # Disable soft-mixer for input devices.
      actions.update-props."api.alsa.soft-mixer" = false;
      matches = [
        {
          "device.name" = "~alsa_card.*";
          "node.name" = "~alsa_input.*";
        }
      ];
    }
    {
      # Disable audio session suspension.
      # Fix bug with plugged in headphones.
      # Based on https://github.com/mudkipme/awesome-minisforum-v3?tab=readme-ov-file#disable-audio-session-suspension (Disable audio session suspension)
      actions.update-props."session.suspend-timeout-seconds" = "0";
      matches = [
        {
          "node.name" = "~alsa_input.*";
        }
        {
          "node.name" = "~alsa_output.*";
        }
      ];
    }
  ];

}
