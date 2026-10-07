{ lib, ... }:

{
  imports = [
    (lib.mkRemovedOptionModule
      [
        "hardware"
        "raspberry-pi"
        "4"
        "leds"
        "eth"
      ]
      ''
        If hardware.raspberry-pi."4".leds.eth.disable was false, remove the old Ethernet LED configuration.
        If it was true, disable the Pi 4B Ethernet LEDs with dtparam:

          {
            boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
            hardware.raspberry-pi.configtxt.settings."board-type=0x11".dtparam = [
              "eth_led0=4"
              "eth_led1=4"
            ];
          }

        For firmware installation and migration guidance, read "Device tree overlays"
        and "Migrating Pi 4 options" in raspberry-pi/README.md.
      ''
    )
    (lib.mkRemovedOptionModule
      [
        "hardware"
        "raspberry-pi"
        "4"
        "leds"
        "act"
      ]
      ''
        If hardware.raspberry-pi."4".leds.act.disable was false, remove the old activity LED configuration.
        If it was true, use act-led and the trigger parameter to disable the Pi 4B activity LED:

          {
            boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
            hardware.raspberry-pi.configtxt = {
              settings."board-type=0x11".dtparam = [ "act_led_trigger=none" ];
              deviceTreeOverlays."board-type=0x11" = [
                {
                  act-led = {
                    gpio = 42;
                    activelow = false;
                  };
                }
              ];
            };
          }

        act-led retains the old direct GPIO control and polarity.
        For firmware installation and migration guidance, read "Device tree overlays"
        and "Migrating Pi 4 options" in raspberry-pi/README.md.
      ''
    )
    (lib.mkRemovedOptionModule
      [
        "hardware"
        "raspberry-pi"
        "4"
        "leds"
        "pwr"
      ]
      ''
        If hardware.raspberry-pi."4".leds.pwr.disable was false, remove the old power LED configuration.
        If it was true, disable the Pi 4B power LED with dtparam:

          {
            boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
            hardware.raspberry-pi.configtxt.settings."board-type=0x11".dtparam = [
              "pwr_led_trigger=default-on"
              "pwr_led_activelow=off"
            ];
          }

        Keep both parameters to preserve the removed module's polarity and trigger.
        For firmware installation and migration guidance, read "Device tree overlays"
        and "Migrating Pi 4 options" in raspberry-pi/README.md.
      ''
    )
  ];
}
