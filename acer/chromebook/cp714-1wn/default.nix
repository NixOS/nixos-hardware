{ lib, pkgs, ... }:

let
  alsa-ucm-conf-cros = pkgs.callPackage ./alsa-ucm-conf-cros.nix { };
in
{
  environment.systemPackages = [ alsa-ucm-conf-cros ];

  environment.pathsToLink = [ "/share/alsa" ];

  environment.sessionVariables.ALSA_CONFIG_UCM2 = lib.mkDefault "${alsa-ucm-conf-cros}/share/alsa/ucm2";

  services.pipewire.wireplumber.extraConfig."51-increase-headroom" = {
    "monitor.alsa.rules" = [
      {
        matches = [
          {
            "node.name" = "~alsa_output.*";
          }
        ];
        actions = {
          "update-props" = {
            "api.alsa.headroom" = 4096;
          };
        };
      }
    ];
  };
}
