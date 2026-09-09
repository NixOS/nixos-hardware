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
        Use the pwm firmware overlay for PWM0 on GPIO18:

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

        Keep clock = 100000000 to preserve the old 100 MHz clock.
        The empty stock overlay does not set that clock rate.
        For firmware installation, read "Device tree overlays" in
        raspberry-pi/README.md.
      ''
    )
  ];
}
