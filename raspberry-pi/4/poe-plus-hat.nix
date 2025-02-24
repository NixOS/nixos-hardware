{ config, lib, ... }:

let
  cfg = config.hardware.raspberry-pi."4".poe-plus-hat;
in {
  options.hardware = {
    raspberry-pi."4".poe-plus-hat = {
      enable = lib.mkEnableOption ''
        support for the Raspberry Pi PoE+ HAT.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.raspberry-pi."4".apply-overlays-dtmerge.enable = lib.mkDefault true;
    # doesn't work for the CM module, so we exclude e.g. bcm2711-rpi-cm4.dts
    hardware.deviceTree.filter = "bcm2711-rpi-4*.dtb";

    hardware.deviceTree = {
      overlays = [
        # Combined equivalent to:
        # * https://github.com/raspberrypi/linux/blob/rpi-6.6.y/arch/arm/boot/dts/overlays/rpi-poe-overlay.dts
        # * https://github.com/raspberrypi/linux/blob/rpi-6.6.y/arch/arm/boot/dts/overlays/rpi-poe-plus-overlay.dts
        {
          name = "rpi-poe-plus-overlay";
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
                  fan: pwm-fan {
                    compatible = "pwm-fan";
                    cooling-levels = <0 1 10 100 255>;
                    #cooling-cells = <2>;
                    pwms = <&fwpwm 0 80000 0>;
                  };
                };
              };

              fragment@1 {
                target = <&cpu_thermal>;
                __overlay__ {
                  polling-delay = <2000>; /* milliseconds */
                };
              };

              fragment@2 {
                target = <&thermal_trips>;
                __overlay__ {
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
              };

              fragment@3 {
                target = <&cooling_maps>;
                __overlay__ {
                  map0 {
                    trip = <&trip0>;
                    cooling-device = <&fan 0 1>;
                  };
                  map1 {
                    trip = <&trip1>;
                    cooling-device = <&fan 1 2>;
                  };
                  map2 {
                    trip = <&trip2>;
                    cooling-device = <&fan 2 3>;
                  };
                  map3 {
                    trip = <&trip3>;
                    cooling-device = <&fan 3 4>;
                  };
                };
              };

              fragment@4 {
                target-path = "/__overrides__";
                params: __overlay__ {
                  poe_fan_temp0 =		<&trip0>,"temperature:0";
                  poe_fan_temp0_hyst =	<&trip0>,"hysteresis:0";
                  poe_fan_temp1 =		<&trip1>,"temperature:0";
                  poe_fan_temp1_hyst =	<&trip1>,"hysteresis:0";
                  poe_fan_temp2 =		<&trip2>,"temperature:0";
                  poe_fan_temp2_hyst =	<&trip2>,"hysteresis:0";
                  poe_fan_temp3 =		<&trip3>,"temperature:0";
                  poe_fan_temp3_hyst =	<&trip3>,"hysteresis:0";
                  poe_fan_i2c =		<&fwpwm>,"status=disabled",
                        <&poe_mfd>,"status=okay",
                        <&fan>,"pwms:0=",<&poe_mfd_pwm>;
                };
              };

              fragment@5 {
                target = <&firmware>;
                __overlay__ {
                  fwpwm: pwm {
                    compatible = "raspberrypi,firmware-poe-pwm";
                    #pwm-cells = <2>;
                  };
                };
              };

              fragment@6 {
                target = <&i2c0>;
                i2c_bus: __overlay__ {
                  #address-cells = <1>;
                  #size-cells = <0>;

                  poe_mfd: poe@51 {
                    compatible = "raspberrypi,poe-core";
                    reg = <0x51>;
                    status = "disabled";

                    poe_mfd_pwm: poe_pwm@f0 {
                      compatible = "raspberrypi,poe-pwm";
                      reg = <0xf0>;
                      status = "okay";
                      #pwm-cells = <2>;
                    };
                  };
                };
              };

              fragment@7 {
                target = <&i2c0if>;
                __dormant__ {
                  status = "okay";
                };
              };

              fragment@8 {
                target = <&i2c0mux>;
                __dormant__ {
                  status = "okay";
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
                i2c =			<0>, "+5+6",
                      <&fwpwm>,"status=disabled",
                      <&i2c_bus>,"status=okay",
                      <&poe_mfd>,"status=okay",
                      <&fan>,"pwms:0=",<&poe_mfd_pwm>;
              };
            };

            // SPDX-License-Identifier: (GPL-2.0 OR MIT)
            // Overlay for the Raspberry Pi PoE+ HAT.

            / {
              compatible = "brcm,bcm2711";

              fragment@10 {
                target-path = "/";
                __overlay__ {
                  rpi_poe_power_supply: rpi-poe-power-supply {
                    compatible = "raspberrypi,rpi-poe-power-supply";
                    firmware = <&firmware>;
                    status = "okay";
                  };
                };
              };
              fragment@11 {
                target = <&poe_mfd>;
                __overlay__ {
                  rpi-poe-power-supply@f2 {
                    compatible = "raspberrypi,rpi-poe-power-supply";
                    reg = <0xf2>;
                    status = "okay";
                  };
                };
              };

              __overrides__ {
                i2c =	<0>, "+5+6",
                  <&fwpwm>,"status=disabled",
                  <&rpi_poe_power_supply>,"status=disabled",
                  <&i2c_bus>,"status=okay",
                  <&poe_mfd>,"status=okay",
                  <&fan>,"pwms:0=",<&poe_mfd_pwm>;
              };
            };

            &fan {
              cooling-levels = <0 32 64 128 255>;
            };

            &params {
              poe_fan_i2c = <&fwpwm>,"status=disabled",
                      <&rpi_poe_power_supply>,"status=disabled",
                      <&poe_mfd>,"status=okay",
                      <&fan>,"pwms:0=",<&poe_mfd_pwm>;
            };
          '';
        }
      ];
    };
  };
}
