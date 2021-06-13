{ config, lib, pkgs, ... }: {
  imports =
    [ ./kernel ./hardware_configuration.nix ./firmware/surface-go/ath10k ];

  environment.systemPackages = with pkgs; [ surface-control ];
  users.groups.surface-control = { };
  services.udev.packages = [ pkgs.surface-control ];
  systemd.services.iptsd = {
    description = "IPTSD";
    script = "${pkgs.iptsd}/bin/iptsd";
    wantedBy = [ "multi-user.target" ];
  };
}
