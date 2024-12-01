{ config, lib, pkgs, ... }:
let
  cfg = config.hardware.framework.laptop13.audioEnhancement;
in
{
  options = {
    hardware.framework.laptop13.audioEnhancement = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Create a new audio device called "Framework Speakers",
          which applies sound tuning before sending the audio out to the speakers.
          This option requires PipeWire and WirePlumber.

          The filter chain includes the following:
            - Pyschoacoustic bass enhancement
            - Loudness compensation
            - Equalizer
            - Slight compression

          This option has been optimised for the Framework Laptop 13 AMD 7040 series, but should work on all models.

          Before applying, ensure the speakers are set to 100%,
          because the volumes compound and the raw speaker device will be hidden by default.

          You might also need to re-select the default output device.

          In some cases, the added bass will vibrate the keyboard cable leading to a rattling sound,
          a piece of foam can be used to mitigate this.
        '';
      };

      hideRawDevice = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Hide the raw speaker device.
          This option is enabled by default, because keeping the raw speaker device can lead to volume conflicts.
        '';
      };

      rawDeviceName = lib.mkOption {
        type = lib.types.str;
        example = "alsa_output.pci-0000_c1_00.6.analog-stereo";
        description = ''
          The name of the raw speaker device. This will vary by device.
          You can get this by running `pw-dump | grep -C 20 pci-0000`.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable (let
    outputName = cfg.rawDeviceName;
    prettyName = "Framework Speakers";

    # These are pre-made decibel to linear value conversions, since Nix doesn't have pow().
    # Use the formula `10 ** (db / 20)` to calculate.
    db = {
      "-18.1" = 0.1244514611771385;
      "-5.48" = 0.5321082592667942;
      "-4.76" = 0.5780960474057181;
      "8.1" = 2.5409727055493048;
      "-36" = 1.5848931924611134e-2;
    };

    json = pkgs.formats.json { };

    # The filter chain, heavily inspired by the asahi-audio project: https://github.com/AsahiLinux/asahi-audio
    filter-chain = json.generate "filter-chain.json" {
      "node.description" = prettyName;
      "media.name" = prettyName;
      "filter.graph" = {
        nodes = [
          # Psychoacoustic bass extension,
          # it creates harmonics of the missing bass to fool our ears into hearing it.
          {
            type = "lv2";
            plugin = "https://chadmed.au/bankstown";
            name = "bassex";
            control = {
              bypass = 0;
              amt = 1.2;
              sat_second = 1.3;
              sat_third = 2.5;
              blend = 1.0;
              ceil = 200.0;
              floor = 20.0;
            };
          }
          # Loudness compensation,
          # it ensures that the sound profile stays consistent across different volumes.
          {
            type = "lv2";
            plugin = "http://lsp-plug.in/plugins/lv2/loud_comp_stereo";
            name = "el";
            control = {
              enabled = 1;
              input = 1.0;
              fft = 4;
            };
          }
          # 8-band equalizer,
          # it tries to lessen frequencies where the laptop might resonate,
          # and tries to make the frequency curve more pleasing;
          # this is the "Lappy McTopface" profile (https://github.com/ceiphr/ee-framework-presets)
          # further tuned for the Framework Laptop 13 AMD 7040 series
          # and might need some tuning on other models.
          {
            type = "lv2";
            plugin = "http://lsp-plug.in/plugins/lv2/para_equalizer_x8_lr";
            name = "fw13eq";
            control = {
              mode = 0;
              react = 0.2;
              zoom = db."-36";

              fl_0 = 101.0;
              fml_0 = 0;
              ftl_0 = 5;
              gl_0 = db."-18.1";
              huel_0 = 0.0;
              ql_0 = 4.36;
              sl_0 = 0;
              wl_0 = 4.0;

              fl_1 = 451.0;
              fml_1 = 0;
              ftl_1 = 1;
              gl_1 = db."-5.48";
              huel_1 = 3.125e-2;
              ql_1 = 2.46;
              sl_1 = 0;
              wl_1 = 4.0;

              fl_2 = 918.0;
              fml_2 = 0;
              ftl_2 = 1;
              gl_2 = db."-4.76";
              huel_2 = 6.25e-2;
              ql_2 = 2.44;
              sl_2 = 0;
              wl_2 = 4.0;

              fl_3 = 9700.0;
              fml_3 = 0;
              ftl_3 = 1;
              gl_3 = db."8.1";
              huel_3 = 9.375e-2;
              ql_3 = 2.0;
              sl_3 = 0;
              wl_3 = 4.0;

              fr_0 = 101.0;
              fmr_0 = 0;
              ftr_0 = 5;
              gr_0 = db."-18.1";
              huer_0 = 0.0;
              qr_0 = 4.36;
              sr_0 = 0;
              wr_0 = 4.0;

              fr_1 = 451.0;
              fmr_1 = 0;
              ftr_1 = 1;
              gr_1 = db."-5.48";
              huer_1 = 3.125e-2;
              qr_1 = 2.46;
              sr_1 = 0;
              wr_1 = 4.0;

              fr_2 = 918.0;
              fmr_2 = 0;
              ftr_2 = 1;
              gr_2 = db."-4.76";
              huer_2 = 6.25e-2;
              qr_2 = 2.44;
              sr_2 = 0;
              wr_2 = 4.0;

              fr_3 = 9700.0;
              fmr_3 = 0;
              ftr_3 = 1;
              gr_3 = db."8.1";
              huer_3 = 9.375e-2;
              qr_3 = 2.0;
              sr_3 = 0;
              wr_3 = 4.0;
            };
          }
          # Compressors. The settings were taken from the asahi-audio project.
          {
            type = "lv2";
            plugin = "http://lsp-plug.in/plugins/lv2/mb_compressor_stereo";
            name = "woofer_bp";
            control = {
              mode = 0;
              ce_0 = 1;
              sla_0 = 5.0;
              cr_0 = 1.75;
              al_0 = 0.725;
              at_0 = 1.0;
              rt_0 = 100;
              kn_0 = 0.125;
              cbe_1 = 1;
              sf_1 = 200.0;
              ce_1 = 0;
              cbe_2 = 0;
              ce_2 = 0;
              cbe_3 = 0;
              ce_3 = 0;
              cbe_4 = 0;
              ce_4 = 0;
              cbe_5 = 0;
              ce_5 = 0;
              cbe_6 = 0;
              ce_6 = 0;
            };
          }
          {
            type = "lv2";
            plugin = "http://lsp-plug.in/plugins/lv2/compressor_stereo";
            name = "woofer_lim";
            control = {
              sla = 5.0;
              al = 1.0;
              at = 1.0;
              rt = 100.0;
              cr = 15.0;
              kn = 0.5;
            };
          }
        ];

        # Now, we're chaining together the modules instantiated above.
        links = [
          {
            output = "bassex:out_l";
            input = "el:in_l";
          }
          {
            output = "bassex:out_r";
            input = "el:in_r";
          }

          {
            output = "el:out_l";
            input = "fw13eq:in_l";
          }
          {
            output = "el:out_r";
            input = "fw13eq:in_r";
          }
          {
            output = "fw13eq:out_l";
            input = "woofer_bp:in_l";
          }
          {
            output = "fw13eq:out_r";
            input = "woofer_bp:in_r";
          }
          {
            output = "woofer_bp:out_l";
            input = "woofer_lim:in_l";
          }
          {
            output = "woofer_bp:out_r";
            input = "woofer_lim:in_r";
          }
        ];

        inputs = [
          "bassex:in_l"
          "bassex:in_r"
        ];
        outputs = [
          "woofer_lim:out_l"
          "woofer_lim:out_r"
        ];

        # This makes pipewire's volume control actually control the loudness comp module
        "capture.volumes" = [
          {
            control = "el:volume";
            min = -47.5;
            max = 0.0;
            scale = "cubic";
          }
        ];
      };
      "capture.props" = {
        "node.name" = "audio_effect.laptop-convolver";
        "media.class" = "Audio/Sink";
        "audio.channels" = "2";
        "audio.position" = [
          "FL"
          "FR"
        ];
        "audio.allowed-rates" = [
          44100
          48000
          88200
          96000
          176400
          192000
        ];
        "device.api" = "dsp";
        "node.virtual" = "false";

        # Lower seems to mean "more preferred",
        # bluetooth devices seem to be ~1000, speakers seem to be ~2000
        # since this is between the two, bluetooth devices take over when they connect,
        # and hand over to this instead of the speakers when they disconnect.
        "priority.session" = 1500;
        "priority.driver" = 1500;
        "state.default-volume" = 0.343;
        "device.icon-name" = "audio-card-analog-pci";
      };
      "playback.props" = {
        "node.name" = "audio_effect.laptop-convolver";
        "target.object" = outputName;
        "node.passive" = "true";
        "audio.channels" = "2";
        "audio.allowed-rates" = [
          44100
          48000
          88200
          96000
          176400
          192000
        ];
        "audio.position" = [
          "FL"
          "FR"
        ];
        "device.icon-name" = "audio-card-analog-pci";
      };
    };

    configPackage =
      (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/99-laptop.conf" ''
        monitor.alsa.rules = [
          {
            matches = [{ node.name = "${outputName}" }]
            actions = {
              update-props = {
                audio.allowed-rates = [44100, 48000, 88200, 96000, 176400, 192000]
              }
            }
          }
        ]

        node.software-dsp.rules = [
          {
            matches = [{ node.name = "${outputName}" }]
            actions = {
              create-filter = {
                filter-path = "${filter-chain}"
                hide-parent = ${lib.boolToString cfg.hideRawDevice}
              }
            }
          }
        ]

        wireplumber.profiles = {
          main = { node.software-dsp = "required" }
        }
      '')
      // {
        passthru.requiredLv2Packages = with pkgs; [
          lsp-plugins
          bankstown-lv2
        ];
      };
  in {
    services.pipewire.wireplumber.configPackages = [ configPackage ];

    # Pipewire is needed for this.
    services.pipewire.enable = lib.mkDefault true;
  });
}
