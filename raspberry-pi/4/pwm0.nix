{ lib, ... }:

{
  imports = [
    (lib.mkRemovedOptionModule
      [
        "hardware"
        "raspberry-pi"
        "4"
        "pwm0"
      ]
      ''
        If hardware.raspberry-pi."4".pwm0.enable was false, remove the old PWM0 configuration.
        If it was true, use the pwm firmware overlay for PWM0 on GPIO18:

          {
            boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
            hardware.raspberry-pi.configtxt.deviceTreeOverlays.pi4 = [
              {
                pwm = {
                  pin = 18;
                  func = 2;
                  clock = 100000000;
                };
              }
            ];
          }

        The removed pwm0 module explicitly assigned a 100 MHz clock.
        Keep clock = 100000000 to preserve that assignment.
        Without clock, the stock overlay leaves the base clock configuration unchanged:
        https://github.com/raspberrypi/linux/blob/e165a3e0c5c6729d077c30c6d720c029d688d99d/arch/arm/boot/dts/overlays/pwm-overlay.dts

        For firmware installation and migration guidance, read "Device tree overlays"
        and "Migrating Pi 4 options" in raspberry-pi/README.md.
      ''
    )
  ];
}
