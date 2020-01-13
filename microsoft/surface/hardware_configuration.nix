{ config, lib, pkgs, ... }:
{
  boot.extraModprobeConfig = lib.mkDefault ''
    options i915 enable_fbc=1 enable_rc6=1 modeset=1
    options snd_hda_intel power_save=1
    options snd_ac97_codec power_save=1
    options iwlwifi power_save=Y
    options iwldvm force_cam=N
    options ath10k_core skip_otp=Y
  '';

  boot.kernelParams = [ "mem_sleep_default=deep" ];

  # TLP is known to cause problems on Surface unless correctly configured.
  # See: https://github.com/linux-surface/linux-surface/blob/master/README.md
  services.tlp.enable = lib.mkDefault false;

  hardware.sensor.iio.enable = lib.mkDefault true;
}
