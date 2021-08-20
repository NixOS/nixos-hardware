{ config, lib, pkgs, ... }:

let 
  cfg = config.hardware.raspberry-pi."4".poe-hat;
in {
  options.hardware = {
    raspberry-pi."4".poe-hat = {
      enable = lib.mkEnableOption ''
        support for the Raspberry Pi POE Hat.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # Configure for modesetting in the device tree
    hardware.deviceTree = {
      overlays = [
        # Equivalent to: https://github.com/raspberrypi/linux/blob/rpi-5.10.y/arch/arm/boot/dts/overlays/rpi-poe-overlay.dts
        {
          name = "rpi-poe-overlay";
          dtsText = ''
            /*
            * Overlay for the Raspberry Pi POE HAT.
            */
            /dts-v1/;
            /plugin/;

            / {
              compatible = "brcm,bcm2711";

              fragment@0 {
                target-path = "/";
                __overlay__ {
                  fan0: rpi-poe-fan@0 {
                    compatible = "raspberrypi,rpi-poe-fan";
                    firmware = <&firmware>;
                    cooling-min-state = <0>;
                    cooling-max-state = <4>;
                    #cooling-cells = <2>;
                    cooling-levels = <0 1 10 100 255>;
                    status = "okay";
                  };
                };
              };

              fragment@1 {
                target = <&cpu_thermal>;
                __overlay__ {
                  trips {
                    trip0: trip0 {
                      temperature = <40000>;
                      hysteresis = <2000>;
                      type = "active";
                    };
                    trip1: trip1 {
                      temperature = <45000>;
                      hysteresis = <2000>;
                      type = "active";
                    };
                    trip2: trip2 {
                      temperature = <50000>;
                      hysteresis = <2000>;
                      type = "active";
                    };
                    trip3: trip3 {
                      temperature = <55000>;
                      hysteresis = <5000>;
                      type = "active";
                    };
                  };
                  cooling-maps {
                    map0 {
                      trip = <&trip0>;
                      cooling-device = <&fan0 0 1>;
                    };
                    map1 {
                      trip = <&trip1>;
                      cooling-device = <&fan0 1 2>;
                    };
                    map2 {
                      trip = <&trip2>;
                      cooling-device = <&fan0 2 3>;
                    };
                    map3 {
                      trip = <&trip3>;
                      cooling-device = <&fan0 3 4>;
                    };
                  };
                };
              };

              fragment@2 {
                target-path = "/__overrides__";
                __overlay__ {
                  poe_fan_temp0 =		<&trip0>,"temperature:0";
                  poe_fan_temp0_hyst =	<&trip0>,"hysteresis:0";
                  poe_fan_temp1 =		<&trip1>,"temperature:0";
                  poe_fan_temp1_hyst =	<&trip1>,"hysteresis:0";
                  poe_fan_temp2 =		<&trip2>,"temperature:0";
                  poe_fan_temp2_hyst =	<&trip2>,"hysteresis:0";
                  poe_fan_temp3 =		<&trip3>,"temperature:0";
                  poe_fan_temp3_hyst =	<&trip3>,"hysteresis:0";
                };
              };

              __overrides__ {
                poe_fan_temp0 =		<&trip0>,"temperature:0";
                poe_fan_temp0_hyst =	<&trip0>,"hysteresis:0";
                poe_fan_temp1 =		<&trip1>,"temperature:0";
                poe_fan_temp1_hyst =	<&trip1>,"hysteresis:0";
                poe_fan_temp2 =		<&trip2>,"temperature:0";
                poe_fan_temp2_hyst =	<&trip2>,"hysteresis:0";
                poe_fan_temp3 =		<&trip3>,"temperature:0";
                poe_fan_temp3_hyst =	<&trip3>,"hysteresis:0";
              };
            };
          '';
        }
      ];
    };
  };
}
