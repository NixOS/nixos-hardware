# MIT License

# Copyright (c) 2018-2020 Samuel Dionne-Riel and the Mobile NixOS contributors

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hardware.pinephone-pro.audio;
  ucm-env = config.environment.variables.ALSA_CONFIG_UCM2;
in
{
  options.hardware.pinephone-pro.audio = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        The built-in audio output and input devices do not work out of the box.

        This combines the derivation output path share/alsa/ucm2/ with pkgs.alsa-ucm-conf,
        points ALSA to the result,
        and installs PinePhone Pro specific UCM2 rules.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.pathsToLink = [ "/share/alsa/ucm2" ];
    environment.systemPackages = [
      pkgs.alsa-ucm-conf
      pkgs.pine64-alsa-ucm
    ];

    environment.variables.ALSA_CONFIG_UCM2 = "/run/current-system/sw/share/alsa/ucm2";

    # pulseaudio
    systemd.user.services.pulseaudio.environment.ALSA_CONFIG_UCM2 = ucm-env;
    systemd.services.pulseaudio.environment.ALSA_CONFIG_UCM2 = ucm-env;

    # pipewire
    systemd.user.services.pipewire.environment.ALSA_CONFIG_UCM2 = ucm-env;
    systemd.user.services.pipewire-pulse.environment.ALSA_CONFIG_UCM2 = ucm-env;
    systemd.user.services.wireplumber.environment.ALSA_CONFIG_UCM2 = ucm-env;
    systemd.services.pipewire.environment.ALSA_CONFIG_UCM2 = ucm-env;
    systemd.services.pipewire-pulse.environment.ALSA_CONFIG_UCM2 = ucm-env;
    systemd.services.wireplumber.environment.ALSA_CONFIG_UCM2 = ucm-env;
  };
}
