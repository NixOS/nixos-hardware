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
        To enable PWM0 on GPIO18, use the pwm firmware overlay:

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
        Without clock, the pwm overlay leaves the base clock configuration unchanged:
        https://github.com/raspberrypi/linux/blob/rpi-6.18.y/arch/arm/boot/dts/overlays/pwm-overlay.dts

        Before switching, migrate any remaining hardware.deviceTree.overlays used only in generation DTBs.
        For firmware installation, read "Device tree overlays" in raspberry-pi/README.md.
      ''
    )
  ];
}
