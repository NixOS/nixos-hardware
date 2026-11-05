{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hardware.raspberry-pi.audio;
in
{
  imports = [ ./config-txt.nix ];

  options.hardware.raspberry-pi.audio = {
    enable = lib.mkEnableOption "onboard audio through snd_bcm2835 on Raspberry Pi 2, 3, and 4";
  };

  config = lib.mkIf cfg.enable {
    # Omit FDT/FDTDIR so U-Boot keeps the firmware's audio=on change.
    boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
    boot.kernelModules = [ "snd_bcm2835" ];
    # The board profiles use KMS for HDMI audio. Leave firmware-driven HDMI
    # kernel parameters to users.
    boot.kernelParams = [ "snd_bcm2835.enable_headphones=1" ];

    hardware.raspberry-pi.configtxt.settings = lib.genAttrs [ "pi2" "pi3" "pi4" ] (_: {
      dtparam = [ "audio=on" ];
    });

    # Override NixOS's mkDefault (1000), but let explicit user configuration win.
    services.pulseaudio.configFile = lib.mkOverride 990 (
      pkgs.runCommand "default.pa" { } ''
        substitute ${lib.getBin config.services.pulseaudio.package}/etc/pulse/default.pa "$out" \
          --replace-fail "load-module module-udev-detect" "load-module module-udev-detect tsched=0"
      ''
    );
  };
}
