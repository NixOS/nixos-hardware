{ lib, ... }:

# This module is intended to support the Surface Go range of devices.
# The current version of this targets the Go 1, and other versions of the device may need further
# config changes to work well.

let
  inherit (lib) mkDefault;
in {
  imports = [
    ../common
    ./firmware/ath10k
    ../../../common/pc
    ../../../common/pc/ssd
    # The Intel CPU module auto-includes Intel's GPU:
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
