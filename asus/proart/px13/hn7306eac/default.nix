{
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ../default.nix
    ./tas2783-kernel-patches.nix
  ];

  hardware = {
    alsa.enablePersistence = lib.mkDefault true;
    firmware = lib.optional (lib.versionOlder pkgs.linux-firmware.version "20260519") (
      pkgs.callPackage ./tas2783-firmware.nix { }
    );
  };

  environment.etc = {
    "alsa/ucm2/codecs/tas2783/init.conf".source = ./ucm2/codecs/tas2783/init.conf;
    "alsa/ucm2/sof-soundwire/acp-dmic.conf".source = ./ucm2/sof-soundwire/acp-dmic.conf;
    "alsa/ucm2/sof-soundwire/tas2783.conf".source = ./ucm2/sof-soundwire/tas2783.conf;
    "alsa/ucm2/sof-soundwire/sof-soundwire.conf".source = ./ucm2/sof-soundwire/sof-soundwire.conf;
  };

  # WirePlumber config for TAS2783 smart amp speakers.
  # UCM doesn’t expose a Speakers port for this card, so force pro-audio and
  # prevent the speaker sink from suspending (prevents desync on idle).
  # Firmware extraction recipe and original config:
  # https://gist.github.com/cryptob1/f62aaf8517df2e540f447347f42c7a03
  services.pipewire.wireplumber.extraConfig."51-strix-halo-audio" = {
    "monitor.alsa.rules" = [
      {
        matches = [
          { "device.name" = "alsa_card.pci-0000_c4_00.5-platform-amd_sdw"; }
        ];
        actions."update-props" = {
          "device.profile" = "pro-audio";
        };
      }
      {
        matches = [
          { "node.name" = "alsa_output.pci-0000_c4_00.5-platform-amd_sdw.pro-output-2"; }
        ];
        actions."update-props" = {
          "session.suspend-timeout-seconds" = 0;
          "node.description" = "Internal Speakers (TAS2783)";
          "priority.session" = 2300;
        };
      }
    ];
  };

  # Unmute the TAS2783 once detected.
  services.udev.extraRules =
    let
      amixer = "${lib.getBin pkgs.alsa-utils}/bin/amixer";
    in
    /* udev */ ''
      ACTION=="add", SUBSYSTEM=="sound", ATTR{id}=="sofsoundwire", RUN+="${amixer} -c $attr{number} set 'tas2783-1 Amp Playback Switch' 1"

      ACTION=="add", SUBSYSTEM=="sound", ATTR{id}=="amdsoundwire", RUN+="${amixer} -c $attr{number} set 'tas2783-1 Amp' on"
      ACTION=="add", SUBSYSTEM=="sound", ATTR{id}=="amdsoundwire", RUN+="${amixer} -c $attr{number} set 'tas2783-2 Amp' on"
      ACTION=="add", SUBSYSTEM=="sound", ATTR{id}=="amdsoundwire", RUN+="${amixer} -c $attr{number} set 'tas2783-1 Speaker' on"
      ACTION=="add", SUBSYSTEM=="sound", ATTR{id}=="amdsoundwire", RUN+="${amixer} -c $attr{number} set 'tas2783-2 Speaker' on"
    '';
}
