{ lib, pkgs, ... }:

let
  alsa-ucm-conf-cros = pkgs.callPackage ./alsa-ucm-conf-cros.nix { };
in {
  imports = [
  ../../../common/cpu/intel/kaby-lake
  ../../../common/pc/laptop
  ../../../common/hidpi.nix 
  ];
  boot.extraModprobeConfig = ''
    options snd-intel-dspcfg dsp_driver=4
    options snd-soc-avs ignore_fw_version=1
    options snd-soc-avs obsolete_card_names=1
  '';
  environment.sessionVariables.ALSA_CONFIG_UCM2 = lib.mkDefault "${alsa-ucm-conf-cros}/share/alsa/ucm2";
}

