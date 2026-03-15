# Default config.txt settings matching the official Raspberry Pi OS defaults.
#
# Source: https://github.com/RPi-Distro/pi-gen/blob/master/stage1/00-boot-files/files/config.txt
# All values use mkDefault so they can be easily overridden.
#
# Reference: https://www.raspberrypi.com/documentation/computers/config_txt.html

{ lib, ... }:

{
  hardware.raspberry-pi.configtxt.settings = {
    all = {
      camera_auto_detect = lib.mkDefault true;
      display_auto_detect = lib.mkDefault true;
      max_framebuffers = lib.mkDefault 2;
      disable_fw_kms_setup = lib.mkDefault true;
      disable_overscan = lib.mkDefault true;
      arm_boost = lib.mkDefault true;
      dtparam = lib.mkDefault [ "audio=on" ];
      dtoverlay = lib.mkDefault [ "vc4-kms-v3d" ];
    };
    cm4 = {
      otg_mode = lib.mkDefault true;
    };
    cm5 = {
      dtoverlay = lib.mkDefault [ "dwc2,dr_mode=host" ];
    };
  };
}
