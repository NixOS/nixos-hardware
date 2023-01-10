{ lib, ... }:

let
  inherit (lib) mkDefault;
in {
  imports = [
    ../common
    ./firmware/ath10k
    ../../../common/pc
    ../../../common/pc/ssd
    ../../../common/cpu/intel
    ../../../common/cpu/intel/kaby-lake
  ];

  boot.kernelParams = [
    "i915.enable_rc6=1"
    "i915.modeset=1"
  ];

  boot.extraModprobeConfig = mkDefault ''
    options snd_hda_intel power_save=1
    options snd_ac97_codec power_save=1
    options iwlwifi power_save=Y
    options iwldvm force_cam=N
  '';
}
