{
  lib,
  config,
  pkgs,
  ...
}:
let
  # Patch the upstream UCM definitions until the fixes land in alsa-ucm-conf.
  # Use a mostly-symlinked tree and only materialize patched files to keep
  # closure size down.
  ucm2Patched =
    pkgs.runCommand "alsa-ucm2-patched-fw16-ai300"
      {
        nativeBuildInputs = [ pkgs.patch ];
      }
      ''
        set -euo pipefail

        ucmSrc="${pkgs.alsa-ucm-conf}/share/alsa/ucm2"
        ucmOut="$out/share/alsa/ucm2"
        patchDir=${./ucm-patches}

        mkdir -p "$out/share/alsa"
        cp -as "$ucmSrc" "$out/share/alsa/"

        # Make editable, materialize, patch, and sanity-check the targets.
        for f in HDA/HiFi-analog.conf HDA/HiFi-mic.conf; do
          chmod u+w "$ucmOut/$f"
          cp --remove-destination "$ucmSrc/$f" "$ucmOut/$f"
          patch -p1 -d "$out/share/alsa" < "$patchDir/$f.patch"
          test -f "$ucmOut/$f"
        done
      '';

  ucm2Path = "${ucm2Patched}/share/alsa/ucm2";
in
{
  # Point ALSA / PipeWire / WirePlumber at the patched UCM profiles so the
  # Headphones and HDA capture devices are only created when the relevant
  # controls are present. Without this, FW16, which has no physical 3.5mm
  # jack, exposes silent devices.
  systemd.user.services = lib.mkIf config.services.pipewire.enable {
    pipewire.environment.ALSA_CONFIG_UCM2 = lib.mkDefault ucm2Path;
    pipewire-pulse.environment.ALSA_CONFIG_UCM2 = lib.mkDefault ucm2Path;
    wireplumber.environment.ALSA_CONFIG_UCM2 = lib.mkDefault ucm2Path;
  };
}
