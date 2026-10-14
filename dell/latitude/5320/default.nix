{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../../../common/cpu/intel/tiger-lake
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  # Important Firmware
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  # Start the driver at boot
  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };

  # this enable the fingerprint sensor
  services.fprintd.enable = lib.mkDefault true;
  # fprintd is not enough we need the fork with the supported devices https://gitlab.freedesktop.org/3v1n0/libfprint/-/blob/tod/README.tod.md
  services.fprintd.tod.enable = lib.mkDefault true;
  # for my device, I need this driver
  # https://discussion.fedoraproject.org/t/broadcom-58200-fingerprint-driver-open-source-driver-released-can-we-add-to-fedora-repos/139332
  services.fprintd.tod.driver = lib.mkDefault true pkgs.libfprint-2-tod1-broadcom;
}
