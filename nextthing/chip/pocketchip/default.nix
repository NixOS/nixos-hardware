{ pkgs, lib, ... }:

{
  imports = [ ../. ];

  nixpkgs.overlays = [
    (_final: prev: {
      ubootCHIP = prev.ubootCHIP.override (old: {
        extraConfig = (old.extraConfig or "") + ''
          CONFIG_VIDEO_LCD_MODE="x:480,y:272,depth:18,pclk_khz:9000,le:10,ri:5,up:3,lo:8,hs:30,vs:5,sync:3,vmode:0"
          CONFIG_VIDEO_LCD_POWER="AXP0-1"
          CONFIG_VIDEO_LCD_BL_EN="PD18"
          CONFIG_VIDEO_LCD_BL_PWM="PB2"
          CONFIG_VIDEO_LCD_BL_PWM_ACTIVE_LOW=y
          CONFIG_AXP_GPIO=y
        '';
      });
    })
  ];

  hardware.deviceTree =
    let
      chip-dt-overlays = pkgs.fetchFromGitHub {
        owner = "chuangzhu";
        repo = "CHIP-dt-overlays";
        rev = "e684a6e59f11990678bd968a662f5e7a19f7aeea";
        hash = "sha256-N3d6MgRBpgR4xPgI8WWUQRu4dhC/hGSvOAIZD9ymKos=";
      };
    in
    {
      dtboBuildExtraIncludePaths = [ chip-dt-overlays ];
      overlays = [
        {
          name = "dip-pocket-v73";
          dtsFile = "${chip-dt-overlays}/nextthingco/dip-pocket-v73.dts";
        }

        # The keyboard I2C sometimes locks up at default speed
        {
          name = "lower-keyboard-i2c-speed";
          dtsText = ''
            /dts-v1/;
            /plugin/;
            / {
              compatible = "nextthing,chip";
            };
            &i2c1 {
              clock-frequency = <10000>;
            };
          '';
        }
      ];
    };

  boot.kernelParams = [
    "video=Unknown-1:e" # LCD
    "video=Composite-1:d"
  ];

  # RTP driver in mainline kernel does not support touchscreen-inverted-{x,y}
  services.udev.extraRules = ''
    ENV{ID_PATH}=="platform-1c25000.rtp", ENV{LIBINPUT_CALIBRATION_MATRIX}="-1 0 1  0 -1 1"
  '';

  services.xserver.xkb.extraLayouts = {
    pocketchip = {
      description = "PocketCHIP Keyboard";
      languages = [ "eng" ];
      symbolsFile = ./pocketchip.symbols;
    };
  };
  services.xserver.xkb.layout = lib.mkDefault "us+pocketchip";
  console.useXkbConfig = lib.mkDefault true;

  services.logind.settings.Login.HandlePowerKey = lib.mkDefault "ignore";
}
