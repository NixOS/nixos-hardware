{
  config,
  lib,
  options,
  pkgs,
  ...
}:

let
  cfg = config.hardware.raspberry-pi.audio;
in
{
  options.hardware.raspberry-pi.audio = {
    enable = lib.mkEnableOption "onboard audio through snd_bcm2835 on Raspberry Pi 2, 3, and 4";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.hardware.deviceTree.overlays == [ ];
        message = ''
          hardware.raspberry-pi.audio.enable uses the firmware-provided device tree
          and cannot be combined with hardware.deviceTree.overlays.
          Migrate those overlays to hardware.raspberry-pi.configtxt.deviceTreeOverlays.
          See "Device tree overlays" in raspberry-pi/README.md for migration and
          firmware installation.
        '';
      }
      {
        assertion = !config.boot.loader.generic-extlinux-compatible.useGenerationDeviceTree;
        message = ''
          hardware.raspberry-pi.audio.enable requires
          boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false
          so U-Boot keeps the firmware's audio configuration.
          Remove the conflicting override or set it to false.
        '';
      }
      {
        assertion = config.hardware.raspberry-pi.firmware.enable || (options ? sdImage);
        message = ''
          Outside SD-image builds, hardware.raspberry-pi.audio.enable requires
          hardware.raspberry-pi.firmware.enable = true to install the firmware configuration.
          Enable automatic firmware installation as described in "Firmware install" in raspberry-pi/README.md.
        '';
      }
    ];

    # Omit FDT/FDTDIR so U-Boot keeps the firmware's audio=on change.
    boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = lib.mkDefault false;
    # The board profiles use KMS for HDMI audio. Leave firmware-driven HDMI
    # kernel parameters to users.
    boot.kernelModules = [ "snd_bcm2835" ];

    services.pulseaudio.configFile =
      lib.pipe
        {
          name = "default.pa";
          src = "${lib.getBin config.services.pulseaudio.package}/etc/pulse/default.pa";
          substitutions = [
            "--replace-fail"
            "load-module module-udev-detect"
            "load-module module-udev-detect tsched=0"
          ];
        }
        [
          pkgs.substitute
          # Override NixOS's mkDefault (1000), but let explicit user configuration win.
          (lib.mkOverride 990)
        ];
  };
}
