# Rendering tests for config.txt. Board profile builds only prove the module
# evaluates, not that the output is right.
#
# Each case diffs the generated file against an expected one at build time,
# which avoids import-from-derivation.
#
# nix build .#checks.<system>.raspberry-pi-config-txt

{
  lib,
  pkgs,
  runCommand,
  writeText,
}:

let
  configtxt = ../raspberry-pi/common/config-txt.nix;

  # Render without a full NixOS evaluation.
  render =
    module:
    (lib.evalModules {
      modules = [
        configtxt
        { _module.args = { inherit pkgs; }; }
        module
      ];
    }).config.hardware.raspberry-pi.configtxt.file;

  cases = {
    empty = {
      module = { };
      expected = "";
    };

    settingsOnly = {
      module = {
        hardware.raspberry-pi.configtxt.settings.all.arm_boost = true;
      };
      expected = ''
        [all]
        arm_boost=1
      '';
    };

    settingsValueTypes = {
      module = {
        hardware.raspberry-pi.configtxt.settings.all = {
          yes = true;
          no = false;
          num = 2;
          text = "abc";
        };
      };
      expected = ''
        [all]
        no=0
        num=2
        text=abc
        yes=1
      '';
    };

    stackedFilters = {
      module = {
        hardware.raspberry-pi.configtxt.settings.pi4."gpio4=1".arm_freq = 1000;
      };
      expected = ''
        [all]
        [gpio4=1]
        [pi4]
        arm_freq=1000
      '';
    };

    # "all" is stripped before sorting, so all.z lands after b.
    groupSortOrder = {
      module = {
        hardware.raspberry-pi.configtxt.settings = {
          all.z.foo = 1;
          b.bar = 2;
        };
      };
      expected = ''
        [all]
        [b]
        bar=2

        [all]
        [z]
        foo=1
      '';
    };

    # This is what makes mkForce null remove a default.
    nullDropsOut = {
      module = {
        hardware.raspberry-pi.configtxt.settings.all = {
          kept = true;
          dropped = null;
        };
      };
      expected = ''
        [all]
        kept=1
      '';
    };

    listsRepeatKeys = {
      module = {
        hardware.raspberry-pi.configtxt.settings.all.dtparam = [
          "audio=on"
          "i2c_arm=on"
        ];
      };
      expected = ''
        [all]
        dtparam=audio=on
        dtparam=i2c_arm=on
      '';
    };

    overlayWithParams = {
      module = {
        hardware.raspberry-pi.configtxt.deviceTreeOverlays.all = [
          { dwc2.dr_mode = "host"; }
        ];
      };
      expected = ''
        [all]
        dtoverlay=dwc2
        dtparam=dr_mode=host
        dtoverlay=
      '';
    };

    # Overlay parameters use on/off, unlike settings.
    overlayBooleans = {
      module = {
        hardware.raspberry-pi.configtxt.deviceTreeOverlays.all = [
          {
            example = {
              yes = true;
              no = false;
              dropped = null;
            };
          }
        ];
      };
      expected = ''
        [all]
        dtoverlay=example
        dtparam=no=off
        dtparam=yes=on
        dtoverlay=
      '';
    };

    duplicateOverlays = {
      module = {
        hardware.raspberry-pi.configtxt.deviceTreeOverlays.all = [
          { mcp251xfd.interrupt = 25; }
          { mcp251xfd.interrupt = 24; }
        ];
      };
      expected = ''
        [all]
        dtoverlay=mcp251xfd
        dtparam=interrupt=25
        dtoverlay=
        dtoverlay=mcp251xfd
        dtparam=interrupt=24
        dtoverlay=
      '';
    };

    overlayOrder = {
      module = {
        hardware.raspberry-pi.configtxt.deviceTreeOverlays.all = [
          { first = { }; }
          { second = { }; }
        ];
      };
      expected = ''
        [all]
        dtoverlay=first
        dtoverlay=
        dtoverlay=second
        dtoverlay=
      '';
    };

    # all.pi4 and pi4.all are the same filter set, so they merge.
    mergedFilterPaths = {
      module = {
        hardware.raspberry-pi.configtxt.deviceTreeOverlays = {
          all.pi4 = [ { first = { }; } ];
          pi4.all = [ { second = { }; } ];
        };
      };
      expected = ''
        [all]
        [pi4]
        dtoverlay=first
        dtoverlay=
        dtoverlay=second
        dtoverlay=
      '';
    };

    # dtoverlay sorts before dtparam, so rendering settings first is what keeps a
    # base parameter out of an overlay's scope.
    settingsRenderBeforeOverlays = {
      module = {
        hardware.raspberry-pi.configtxt = {
          settings.all.dtparam = [ "audio=on" ];
          deviceTreeOverlays.all = [ { vc4-kms-v3d = { }; } ];
        };
      };
      expected = ''
        [all]
        dtparam=audio=on

        [all]
        dtoverlay=vc4-kms-v3d
        dtoverlay=
      '';
    };
  };

  # One derivation per case, so a single test can be built on its own.
  tests = lib.mapAttrs (
    name: case:
    runCommand "config-txt-${name}" { } ''
      diff -u ${writeText "${name}-expected.txt" case.expected} ${render case.module}
      touch $out
    ''
  ) cases;
in
# Building this builds every case, because naming them here makes them inputs.
# passthru re-exposes each one, so a single case can be built on its own with
# `nix build .#checks.<system>.raspberry-pi-config-txt.<name>`.
runCommand "raspberry-pi-config-txt-tests" {
  cases = lib.attrValues tests;
  passthru = tests;
} "touch $out"
