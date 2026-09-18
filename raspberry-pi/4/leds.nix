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
        To disable the Pi 4B Ethernet LEDs, use the base device-tree parameters:

          {
            boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
            hardware.raspberry-pi.configtxt.settings."board-type=0x11".dtparam = [
              "eth_led0=4"
              "eth_led1=4"
            ];
          }

        For firmware installation, read "Device tree overlays" in
        raspberry-pi/README.md.
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
        To disable the Pi 4B activity LED, use act-led and the trigger parameter:

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
        For firmware installation, read "Device tree overlays" in
        raspberry-pi/README.md.
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
        To disable the Pi 4B power LED, use the base device-tree parameters:

          {
            boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
            hardware.raspberry-pi.configtxt.settings."board-type=0x11".dtparam = [
              "pwr_led_trigger=default-on"
              "pwr_led_activelow=off"
            ];
          }

        Keep both parameters to preserve the old polarity and trigger.
        For firmware installation, read "Device tree overlays" in
        raspberry-pi/README.md.
      ''
    )
  ];
}
