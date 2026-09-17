# Default config.txt settings matching the official Raspberry Pi OS defaults.
#
# Source: https://github.com/RPi-Distro/pi-gen/blob/master/stage1/00-boot-files/files/config.txt
# All values use mkDefault so they can be easily overridden.
#
# Reference: https://www.raspberrypi.com/documentation/computers/config_txt.html

{ lib, ... }:

{
  hardware.raspberry-pi.configtxt = {
    settings = {
      all = {
        camera_auto_detect = lib.mkDefault true;
        display_auto_detect = lib.mkDefault true;
        max_framebuffers = lib.mkDefault 2;
        disable_fw_kms_setup = lib.mkDefault true;
        disable_overscan = lib.mkDefault true;
        arm_boost = lib.mkDefault true;
        # A base DTB parameter rather than an overlay one, so it stays here. It
        # has to apply before any overlay loads: vc4-kms-v3d exports its own
        # `audio` parameter, which would otherwise capture this line and set
        # HDMI audio instead of enabling the onboard audio.
        dtparam = lib.mkDefault [ "audio=on" ];
        # U-Boot needs the UART enabled to boot (see arch/arm/mach-bcm283x/Kconfig
        # in the U-Boot tree). Without it U-Boot hangs on the Pi 4.
        enable_uart = lib.mkDefault true;
      };
      # The Pi 5 has a dedicated debug UART. Leaving the mini UART on feeds ghost
      # input into boot, so turn it back off.
      pi5 = {
        enable_uart = lib.mkDefault false;
      };
      cm4 = {
        otg_mode = lib.mkDefault true;
      };
    };

    deviceTreeOverlays = {
      all = lib.mkDefault [ { vc4-kms-v3d = { }; } ];
      cm5 = lib.mkDefault [ { dwc2.dr_mode = "host"; } ];
    };
  };
}
