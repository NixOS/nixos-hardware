{ lib, ... }:

{
  imports = [
    (lib.mkRemovedOptionModule
      [
        "hardware"
        "raspberry-pi"
        "4"
        "digi-amp-plus"
      ]
      ''
        Use the stock iqaudio-dacplus firmware overlay instead:

          {
            boot.loader.generic-extlinux-compatible.useGenerationDeviceTree =
              false;

            hardware.raspberry-pi.configtxt.deviceTreeOverlays.pi4 = [
              {
                iqaudio-dacplus = {
                  auto_mute_amp = true;
                  unmute_amp = false;
                };
              }
            ];
          }

        Keep the old boolean values. Map autoMuteAmp to auto_mute_amp and
        unmuteAmp to unmute_amp.

        On a running system, set hardware.raspberry-pi.firmware.enable to true.

        For NixOS-Hardware specific firmware setup, read:
        raspberry-pi/README.md.

        For digiamp specific details, see:
        https://www.raspberrypi.com/documentation/accessories/audio.html#raspberry-pi-digiamp
      ''
    )
  ];
}
