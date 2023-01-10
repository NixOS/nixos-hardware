{ lib, pkgs, ... }:

let
  inherit (lib) mkDefault;

in {
  imports = [
    ./common
    ./surface-go/firmware/ath10k
  ];

  boot.extraModprobeConfig = mkDefault ''
    options i915 enable_fbc=1 enable_rc6=1 modeset=1
    options snd_hda_intel power_save=1
    options snd_ac97_codec power_save=1
    options iwlwifi power_save=Y
    options iwldvm force_cam=N
  '';

  environment.systemPackages = [
    pkgs.surface-control
  ];
  users.groups.surface-control = { };
  services.udev.packages = [
    pkgs.surface-control
  ];

  systemd.services.iptsd = {
    description = "IPTSD";
    script = "${pkgs.iptsd}/bin/iptsd";
    wantedBy = [
      "multi-user.target"
    ];
  };
}
