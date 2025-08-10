{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.hardware.orange-pi."5-max".wireless;
  bcmdhd_sdio = config.boot.kernelPackages.callPackage ./bcmdhd_sdio.nix { };
  orangepi-firmware = pkgs.callPackage ./orangepi-firmware.nix { };
in
{
  options.hardware = {
    orange-pi."5-max".wireless = {
      enable = lib.mkEnableOption "configuration for wireless wlan/bluetooth" // {
        default = config.networking.wireless.enable || config.hardware.bluetooth.enable;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      kernelParams = [ "8250.nr_uarts=8" ];
      kernelModules = [
        "bcmdhd_sdio"
        "btbcm"
      ];
      blacklistedKernelModules = [
        "bcmdhd"
        "dhd_static_buf"
      ];
      extraModulePackages = [ bcmdhd_sdio ];
      extraModprobeConfig =
        let
          options = [
            "firmware_path=${orangepi-firmware}/lib/firmware/fw_syn43711a0_sdio.bin"
            "nvram_path=${orangepi-firmware}/lib/firmware/nvram_ap6611s.txt"
            "clm_path=${orangepi-firmware}/lib/firmware/clm_syn43711a0.blob"
          ];
        in
        ''
          options bcmdhd_sdio ${lib.concatStringsSep " " options}
        '';
    };

    hardware = {
      deviceTree = {
        overlays =
          [
            {
              name = "orangepi-5-max-wlan";
              dtsText = ''
                /dts-v1/;
                /plugin/;

                #include <dt-bindings/gpio/gpio.h>
                #include <dt-bindings/pinctrl/rockchip.h>

                / {
                  compatible = "xunlong,orangepi-5-max";
                };
                / {
                  fragment@0 {
                    target = <&pinctrl>;
                    __overlay__ {
                      sdio-pwrseq {
                        wifi_enable_h: wifi-enable-h {
                          rockchip,pins = <2 RK_PC5 RK_FUNC_GPIO &pcfg_pull_none>;
                        };
                      };
                      wireless-wlan {
                        wifi_host_wake_irq: wifi-host-wake-irq {
                          rockchip,pins = <0 RK_PB0 RK_FUNC_GPIO &pcfg_pull_down>;
                        };
                      };
                    };
                  };
                  fragment@1 {
                    target-path = "/";
                    __overlay__ {
                      sdio_pwrseq: sdio-pwrseq {
                        compatible = "mmc-pwrseq-simple";
                        clocks = <&hym8563>;
                        clock-names = "ext_clock";
                        pinctrl-names = "default";
                        pinctrl-0 = <&wifi_enable_h>;
                        post-power-on-delay-ms = <200>;
                        reset-gpios = <&gpio2 RK_PC5 GPIO_ACTIVE_LOW>;
                      };
                      wireless_wlan: wireless-wlan {
                        compatible = "wlan-platdata";
                        wifi_chip_type = "ap6611";
                        pinctrl-names = "default";
                        pinctrl-0 = <&wifi_host_wake_irq>;
                        WIFI,host_wake_irq = <&gpio0 RK_PB0 GPIO_ACTIVE_HIGH>;
                        WIFI,poweren_gpio = <&gpio2 RK_PC5 GPIO_ACTIVE_HIGH>;
                        status = "okay";
                      };
                    };
                  };
                  fragment@2 {
                    target = <&sdio>;
                    __overlay__ {
                      max-frequency = <150000000>;
                      no-sd;
                      no-mmc;
                      bus-width = <4>;
                      disable-wp;
                      cap-sd-highspeed;
                      cap-sdio-irq;
                      keep-power-in-suspend;
                      mmc-pwrseq = <&sdio_pwrseq>;
                      non-removable;
                      pinctrl-names = "default";
                      pinctrl-0 = <&sdiom0_pins>;
                      sd-uhs-sdr104;
                      status = "okay";
                      bcmdhd_wlan {
                      	compatible = "android,bcmdhd_wlan";
                        gpio_wl_host_wake = <&gpio0 RK_PB0 GPIO_ACTIVE_HIGH>;
                      };
                    };
                  };
                };
              '';
            }
          ]
          ++ lib.optional (lib.versionOlder pkgs.linux.version "6.16") {
            name = "orangepi-5-max-bt";
            dtsText = ''
              /dts-v1/;
              /plugin/;

              #include <dt-bindings/gpio/gpio.h>
              #include <dt-bindings/pinctrl/rockchip.h>
              #include <dt-bindings/interrupt-controller/irq.h>

              / {
                compatible = "xunlong,orangepi-5-max";
              };
              / {
                fragment@0 {
                  target = <&pinctrl>;
                  __overlay__ {
                    wireless-bluetooth {
                      bt_reg_on: bt-reg-on {
                        rockchip,pins = <4 RK_PC4 RK_FUNC_GPIO &pcfg_pull_none>;
                      };
                      host_wake_bt: host-wake-bt {
                        rockchip,pins = <4 RK_PC5 RK_FUNC_GPIO &pcfg_pull_none>;
                      };
                      bt_wake_host: bt-wake-host {
                        rockchip,pins = <0 RK_PA0 RK_FUNC_GPIO &pcfg_pull_down>;
                      };
                    };
                  };
                };
                fragment@1 {
                  target = <&uart7>;
                  __overlay__ {
                    pinctrl-names = "default";
                    pinctrl-0 = <&uart7m0_xfer &uart7m0_ctsn &uart7m0_rtsn>;
                    uart-has-rtscts;
                    status = "okay";
                    bluetooth {
                      compatible = "brcm,bcm43438-bt";
                      clocks = <&hym8563>;
                      clock-names = "lpo";
                      device-wakeup-gpios = <&gpio4 RK_PC5 GPIO_ACTIVE_HIGH>;
                      interrupt-parent = <&gpio0>;
                      interrupts = <RK_PA0 IRQ_TYPE_EDGE_FALLING>;
                      interrupt-names = "host-wakeup";
                      pinctrl-names = "default";
                      pinctrl-0 = <&bt_reg_on>, <&host_wake_bt>, <&bt_wake_host>;
                      shutdown-gpios = <&gpio4 RK_PC4 GPIO_ACTIVE_HIGH>;
                      vbat-supply = <&vcc_3v3_s3>;
                      vddio-supply = <&vcc_1v8_s3>;
                    };
                  };
                };
              };
            '';
          };
      };
    };
  };
}
