{ config, lib, pkgs, ... }: {
  imports = [
    ./kernel
    ./firmware/surface-go/ath10k
  ];

  boot.extraModprobeConfig = lib.mkDefault ''
    options i915 enable_fbc=1 enable_rc6=1 modeset=1
    options snd_hda_intel power_save=1
    options snd_ac97_codec power_save=1
    options iwlwifi power_save=Y
    options iwldvm force_cam=N
  '';

  boot.kernelParams = [ "mem_sleep_default=deep" ];

  # NOTE: Check the README before enabling TLP:
  services.tlp.enable = lib.mkDefault false;

  # i.e. needed for wifi firmware, see https://github.com/NixOS/nixos-hardware/issues/364
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  hardware.sensor.iio.enable = lib.mkDefault true;

  environment.systemPackages = with pkgs; [ surface-control ];
  users.groups.surface-control = { };
  services.udev.packages = [ pkgs.surface-control ];
  systemd.services.iptsd = {
    description = "IPTSD";
    script = "${pkgs.iptsd}/bin/iptsd";
    wantedBy = [ "multi-user.target" ];
  };
}
