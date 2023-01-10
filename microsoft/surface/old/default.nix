{ lib, pkgs, ... }:

let
  inherit (lib) mkDefault;

in {
  imports = [
    ../common
    ../surface-go/firmware/ath10k
  ];

  boot.extraModprobeConfig = mkDefault ''
    options i915 enable_fbc=1 enable_rc6=1 modeset=1
    options snd_hda_intel power_save=1
    options snd_ac97_codec power_save=1
    options iwlwifi power_save=Y
    options iwldvm force_cam=N
  '';

  microsoft-surface.surface-control.enable = true;
  microsoft-surface.ipts.enable = true;
}
