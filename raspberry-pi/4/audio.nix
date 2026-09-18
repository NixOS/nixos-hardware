{ lib, ... }:

{
  imports = [
    (lib.mkRemovedOptionModule
      [
        "hardware"
        "raspberry-pi"
        "4"
        "audio"
      ]
      ''
        Enable onboard audio through the firmware configuration:

          {
            boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
            hardware.raspberry-pi.configtxt.settings.pi4.dtparam = [ "audio=on" ];
            boot.kernelModules = [ "snd_bcm2835" ];
            boot.kernelParams = [
              "snd_bcm2835.enable_headphones=1"
              "snd_bcm2835.enable_hdmi=0"
            ];
          }

        When U-Boot supplies the kernel command line, keep these kernel parameters.
        U-Boot does not preserve the firmware's audio flags.

        KMS supplies HDMI audio in the default profile.
        For FKMS or the legacy display stack, set snd_bcm2835.enable_hdmi=1 instead.

        The module no longer sets PulseAudio tsched=0. If you still
        need it, provide a custom services.pulseaudio.configFile.

        For firmware installation, read "Device tree overlays" in
        raspberry-pi/README.md.
      ''
    )
  ];
}
