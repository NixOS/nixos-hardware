{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkDefault
    mkIf
    mkOption
    types
    ;

  cfg = config.hardware.dell-xps-14-da14260.speakerTuning;

  # The graph, kept as a literal so it stays diffable against the upstream it was
  # taken from (basecamp/omarchy aa9f0c54, default/audio/tunings/dell-xps14-da14260)
  # -- including its comments, which carry the reasoning behind the numbers.
  # Only the target sink is substituted; upstream substitutes the same spot from
  # its own `sink_pattern` at install time.
  filterChainConf =
    pkgs.writeTextDir "share/pipewire/filter-chain.conf.d/71-xps14-speaker-tuning.conf" ''
      # Dell XPS 14 DA14260 speaker tuning.
      #
      # Biquad chain fitted to the measured response of the xps-audio-linux EasyEffects
      # profile under a dense pink-weighted multitone of 104 bin-aligned tones,
      # followed by a lookahead limiter. Measures 1.24 dB RMS against that reference.
      #
      # Q below 200 Hz is capped at 1.8 on purpose. A closer magnitude fit is possible
      # with high-Q sections, but the reference produces its narrow bass features by
      # convolution, and reproducing them with high-Q biquads swung group delay 31 ms
      # across 63-80 Hz, which smears bass transients. The cap costs 0.33 dB and
      # halves the swing.
      #
      # Channels are wired explicitly because the limiter is a stereo plugin; a mono
      # graph is duplicated per channel and would limit each side independently,
      # shifting the stereo image on bass transients.

      context.modules = [
        { name = libpipewire-module-filter-chain
          args = {
            node.description = "${cfg.sinkDescription}"
            media.name       = "${cfg.sinkDescription}"

            filter.graph = {
              nodes = [
                { type = builtin name = s0_l      label = bq_highpass  control = { "Freq" = 60.9 "Q" = 1.0 } }
                { type = builtin name = s1_l      label = bq_highpass  control = { "Freq" = 60.9 "Q" = 1.0 } }
                { type = builtin name = s2_l      label = bq_peaking   control = { "Freq" = 83.4 "Q" = 1.8 "Gain" = -8.0 } }
                { type = builtin name = s3_l      label = bq_peaking   control = { "Freq" = 100.4 "Q" = 1.59 "Gain" = 7.47 } }
                { type = builtin name = s4_l      label = bq_peaking   control = { "Freq" = 250.5 "Q" = 2.966 "Gain" = -4.7 } }
                { type = builtin name = s5_l      label = bq_peaking   control = { "Freq" = 419.8 "Q" = 3.0 "Gain" = -5.83 } }
                { type = builtin name = s6_l      label = bq_peaking   control = { "Freq" = 631.3 "Q" = 2.515 "Gain" = -10.33 } }
                { type = builtin name = s7_l      label = bq_peaking   control = { "Freq" = 894.4 "Q" = 4.0 "Gain" = -2.42 } }
                { type = builtin name = s8_l      label = bq_peaking   control = { "Freq" = 1355.7 "Q" = 2.884 "Gain" = 6.92 } }
                { type = builtin name = s9_l      label = bq_peaking   control = { "Freq" = 1707.2 "Q" = 1.311 "Gain" = -6.54 } }
                { type = builtin name = s10_l     label = bq_peaking   control = { "Freq" = 3100.0 "Q" = 0.5 "Gain" = -10.09 } }
                { type = builtin name = s11_l     label = bq_peaking   control = { "Freq" = 3200.0 "Q" = 1.048 "Gain" = 3.09 } }
                { type = builtin name = s12_l     label = bq_highshelf control = { "Freq" = 6015.2 "Q" = 1.5 "Gain" = -1.34 } }

                { type = builtin name = s0_r      label = bq_highpass  control = { "Freq" = 60.9 "Q" = 1.0 } }
                { type = builtin name = s1_r      label = bq_highpass  control = { "Freq" = 60.9 "Q" = 1.0 } }
                { type = builtin name = s2_r      label = bq_peaking   control = { "Freq" = 83.4 "Q" = 1.8 "Gain" = -8.0 } }
                { type = builtin name = s3_r      label = bq_peaking   control = { "Freq" = 100.4 "Q" = 1.59 "Gain" = 7.47 } }
                { type = builtin name = s4_r      label = bq_peaking   control = { "Freq" = 250.5 "Q" = 2.966 "Gain" = -4.7 } }
                { type = builtin name = s5_r      label = bq_peaking   control = { "Freq" = 419.8 "Q" = 3.0 "Gain" = -5.83 } }
                { type = builtin name = s6_r      label = bq_peaking   control = { "Freq" = 631.3 "Q" = 2.515 "Gain" = -10.33 } }
                { type = builtin name = s7_r      label = bq_peaking   control = { "Freq" = 894.4 "Q" = 4.0 "Gain" = -2.42 } }
                { type = builtin name = s8_r      label = bq_peaking   control = { "Freq" = 1355.7 "Q" = 2.884 "Gain" = 6.92 } }
                { type = builtin name = s9_r      label = bq_peaking   control = { "Freq" = 1707.2 "Q" = 1.311 "Gain" = -6.54 } }
                { type = builtin name = s10_r     label = bq_peaking   control = { "Freq" = 3100.0 "Q" = 0.5 "Gain" = -10.09 } }
                { type = builtin name = s11_r     label = bq_peaking   control = { "Freq" = 3200.0 "Q" = 1.048 "Gain" = 3.09 } }
                { type = builtin name = s12_r     label = bq_highshelf control = { "Freq" = 6015.2 "Q" = 1.5 "Gain" = -1.34 } }

                { type   = lv2
                  name   = limiter
                  plugin = "http://lsp-plug.in/plugins/lv2/limiter_stereo"
                  control = {
                    # Both default to enabled: "alr" regulates level toward the
                    # threshold and "boost" normalises the threshold up to full
                    # scale. A fixed tuning must switch them off or its tone drifts
                    # with programme level.
                    "alr"   = 0
                    "boost" = 0
                    "g_in"  = 0.5456
                    "th"    = 0.891
                  }
                }
              ]

              links = [
                { output = "s0_l:Out" input = "s1_l:In" }
                { output = "s1_l:Out" input = "s2_l:In" }
                { output = "s2_l:Out" input = "s3_l:In" }
                { output = "s3_l:Out" input = "s4_l:In" }
                { output = "s4_l:Out" input = "s5_l:In" }
                { output = "s5_l:Out" input = "s6_l:In" }
                { output = "s6_l:Out" input = "s7_l:In" }
                { output = "s7_l:Out" input = "s8_l:In" }
                { output = "s8_l:Out" input = "s9_l:In" }
                { output = "s9_l:Out" input = "s10_l:In" }
                { output = "s10_l:Out" input = "s11_l:In" }
                { output = "s11_l:Out" input = "s12_l:In" }
                { output = "s12_l:Out" input = "limiter:in_l" }
                { output = "s0_r:Out" input = "s1_r:In" }
                { output = "s1_r:Out" input = "s2_r:In" }
                { output = "s2_r:Out" input = "s3_r:In" }
                { output = "s3_r:Out" input = "s4_r:In" }
                { output = "s4_r:Out" input = "s5_r:In" }
                { output = "s5_r:Out" input = "s6_r:In" }
                { output = "s6_r:Out" input = "s7_r:In" }
                { output = "s7_r:Out" input = "s8_r:In" }
                { output = "s8_r:Out" input = "s9_r:In" }
                { output = "s9_r:Out" input = "s10_r:In" }
                { output = "s10_r:Out" input = "s11_r:In" }
                { output = "s11_r:Out" input = "s12_r:In" }
                { output = "s12_r:Out" input = "limiter:in_r" }
              ]

              inputs  = [ "s0_l:In" "s0_r:In" ]
              outputs = [ "limiter:out_l" "limiter:out_r" ]
            }

            audio.channels = 2
            audio.position = [ FL FR ]

            capture.props = {
              node.name   = "xps14_speaker_tuning"
              media.class = Audio/Sink
              # Outranks the raw speaker sink (712 on this board) so WirePlumber
              # picks the tuned path by default, and stays under the headphone
              # sink (1000) so plugging headphones in still wins. Both sinks
              # remain selectable; see the option description.
              priority.session = ${toString cfg.sessionPriority}
              # Not a "virtual" device as far as the UI is concerned -- this is
              # how the speakers are meant to be reached, so it gets the speaker
              # icon rather than being filed under loopbacks and null sinks.
              node.virtual     = false
              device.icon-name = "audio-card-analog-pci"
            }
            playback.props = {
              node.name     = "xps14_speaker_tuning_output"
              node.passive  = true
              target.object = "${cfg.sinkName}"
              # This stream is the filter's output and is a movable sink input
              # like any other, so anything that reroutes "all streams" to a newly
              # selected output would drag the processing along with it -- onto
              # headphones, or into the tuning's own sink, which is a cycle. Pin it.
              node.dont-move = true
              # If the speaker sink is not present yet -- the host can start before
              # the device is discovered -- WirePlumber would otherwise link this
              # output to whatever default exists, quietly tuning the wrong device
              # while the tuning sink still looks healthy. Wait for the named
              # target instead. Both keys are needed: without linger WirePlumber
              # destroys the node rather than waiting (see its
              # scripts/linking/find-defined-target.lua).
              node.dont-fallback = true
              node.linger = true
            }
          }
        }
      ]
    ''
    // {
      # The graph ends in an LV2 lookahead limiter. Without the plugin the whole
      # filter-chain fails to instantiate and the tuning sink silently never
      # appears, so it is a hard dependency rather than a suggestion. The pipewire
      # module collects this into the LV2_PATH it hands filter-chain.service.
      passthru.requiredLv2Packages = [ pkgs.lsp-plugins ];
    };
in
{
  options.hardware.dell-xps-14-da14260.speakerTuning = {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Voice the internal speakers with a PipeWire filter-chain, restoring the
        perceptual tuning Dell's Windows DSP layer applies and Linux does not.
        (The stock Linux path already loads Dell's Cirrus smart-amplifier
        firmware; this is the layer on top of it.) Requires PipeWire.

        Thirteen biquads and an LSP-Plugins lookahead limiter, ported from
        [basecamp/omarchy](https://github.com/basecamp/omarchy) `aa9f0c54`, where
        the chain was fitted to the measured response of the
        [xps-audio-linux](https://github.com/spencerbull/xps-audio-linux)
        EasyEffects profile (MIT). No impulse response or other upstream asset is
        redistributed, so this carries no binary blob and is sample-rate
        agnostic.

        This adds a **second** output device, "Laptop Speakers", in front of the
        raw `Speaker` sink, and gives it a high enough session priority
        (`sessionPriority`) that it becomes the default output while leaving
        headphones and HDMI ahead of it. The raw sink stays selectable —
        picking it just bypasses the tuning.

        The two volumes compound, so set the raw `Speaker` sink to 100% once
        (`wpctl set-volume @DEFAULT_AUDIO_SINK@ 1.0` while it is selected, or
        via pavucontrol) and drive volume from the tuned sink afterwards. The
        chain is linear and the limiter's level-dependent stages are switched
        off, so lowering the volume does not change its voicing.

        Off by default: nixos-hardware profiles do not configure sound unless
        the hardware needs it to work at all, and the speakers work untuned.
      '';
    };

    sinkName = mkOption {
      default = "alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi__Speaker__sink";
      type = types.str;
      description = ''
        PipeWire node name of the raw internal speaker sink the tuning is placed
        in front of. The default is what this board enumerates as; check with
        `wpctl status` or `pactl list sinks short` if the tuning sink appears but
        never links (`node.linger` keeps it waiting rather than failing loudly).
      '';
    };

    sinkDescription = mkOption {
      default = "Laptop Speakers";
      type = types.str;
      description = ''
        Display name of the tuned sink, as shown in volume applets and output
        pickers.
      '';
    };

    sessionPriority = mkOption {
      default = 800;
      type = types.int;
      description = ''
        `priority.session` of the tuned sink, which is what WirePlumber sorts
        outputs by when choosing a default. On this board the raw speakers are
        712 and the headphone jack is 1000, so the default sits between them:
        the tuned sink beats the untuned speakers it fronts, and headphones
        still take over when plugged in. Raise it above 1000 to make the
        speakers win over headphones, or lower it below 712 to keep the tuning
        available without making it the default.
      '';
    };
  };

  config = mkIf cfg.enable {
    # Hosted by pipewire's own `filter-chain.service` -- a separate PipeWire
    # *client* (`pipewire -c filter-chain.conf`), not a drop-in for the audio
    # daemon's config. The daemon only reads its config at startup, so a
    # daemon-loaded graph could only be changed by restarting PipeWire, which
    # drops every PulseAudio client's connection. Hosting it in the side client
    # also contains failure: a malformed graph breaks only this unit instead of
    # stopping PipeWire from starting at all.
    services.pipewire.configPackages = [ filterChainConf ];

    # nixpkgs' pipewire module only feeds this unit its LV2_PATH; it does not
    # order it or turn it on. WirePlumber does the linking, so starting before
    # it is up races the speaker device's discovery -- survivable here, since
    # node.linger/node.dont-fallback make the output wait for its named target
    # rather than grabbing the wrong one, but there is no reason to race.
    systemd.user.services.filter-chain = {
      wantedBy = [ "default.target" ];
      wants = [ "wireplumber.service" ];
      after = [ "wireplumber.service" ];
    };

    # Nothing to filter without it.
    services.pipewire.enable = mkDefault true;
  };
}
