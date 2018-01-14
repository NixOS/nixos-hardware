{ config, lib, pkgs, ... }:

# GPD Pocket support
#
# Most of the configuration comes from the Arch Linux Wiki:
# https://wiki.archlinux.org/index.php/GPD_Pocket
#
# Missing:
# - media keys
# - brightness control
# - video over USB-C

rec {
  imports = [
    ../../common/cpu/intel
    ../../common/pc/laptop
  ];

  # kernel
  boot = {
    kernelParams = [ "fbcon=rotate:1" ];
    kernelPackages = lib.mkDefault pkgs.linuxPackages_4_14;
  };

  # wifi
  hardware.firmware = with pkgs; lib.optionals config.nixpkgs.config.allowUnfree [
    #brcmfmac4356-firmware
  ];

  # power management
  services.tlp = {
    extraConfig = ''
      DISK_DEVICES="mmcblk0"
      DISK_IOSCHED="deadline"
    '';
  };

  hardware.pulseaudio = {
    extraConfig = ''
      set-card-profile alsa_card.platform-cht-bsw-rt5645 HiFi
      set-default-sink alsa_output.platform-cht-bsw-rt5645.HiFi__hw_chtrt5645_0__sink
      set-sink-port alsa_output.platform-cht-bsw-rt5645.HiFi__hw_chtrt5645_0__sink [Out] Speaker
    '';
    daemon.config = {
      realtime-scheduling = "no";
    };
  };

  services.xserver = {
    dpi = 168;
    deviceSection = ''
      Option      "AccelMethod"     "sna"
      Option      "TearFree"        "true"
      Option      "DRI"             "3"
    '';
    xrandrHeads = [{
      output= "DSI1";
      primary = true;
      monitorConfig = ''Option "Rotate" "right"'';
    }];
    inputClassSections = [''
      Identifier  "calibration"
      MatchProduct    "Goodix Capacitive TouchScreen"
      Option  "TransformationMatrix" "0 1 0 -1 0 1 0 0 1"
    ''
    ''
      Identifier "GPD trackpoint"
      MatchProduct "SINO WEALTH Gaming Keyboard"
      MatchIsPointer "on"
      Driver "libinput"
      Option "MiddleEmulation" "1"
      Option "ScrollButton" "3"
      Option "ScrollMethod" "button"
    ''];
  };

  environment.variables = {
    GDK_SCALE = lib.mkDefault "2";         # DPI
    MOZ_USE_XINPUT2 = lib.mkDefault "1";   # Firefox touch gestures
  };
}
