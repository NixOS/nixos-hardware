{
  config,
  pkgs,
  lib,
  ...
}:
let
  ap6275pFirmware = pkgs.callPackage ./ap6275p.nix { };
in
{
  imports = [
    ../../rockchip
  ];

  options.hardware.fydetab.duo = {
    enablePanthor = lib.mkEnableOption "Panthor GPU driver";
  };

  config = {
    boot = lib.mkMerge [
      {
        initrd.includeDefaultModules = false;
        kernelPackages = pkgs.callPackage ./kernel.nix { };
        extraModprobeConfig = ''
          options bcmdhd firmware_path=${ap6275pFirmware}/lib/firmware/ap6275p/fw_bcm43752a2_pcie_ag.bin nvram_path=${ap6275pFirmware}/lib/firmware/ap6275p/nvram_AP6275P.txt conf_path=${ap6275pFirmware}/lib/firmware/ap6275p/config.txt
        '';
        kernelParams = [
          "console=ttyFIQ0"
          "console=tty1"
          "console=both"
          "earlycon=uart8250,mmio32,0xfeb50000"
        ];
        kernelModules = [
          "himax_tp"
          "mh248-fyde"
          "hci_uart"
        ];
      }
      (lib.mkIf config.hardware.bluetooth.enable {
        kernelModules = [
          "bluetooth"
        ];
      })
    ];

    hardware = lib.mkMerge [
      {
        deviceTree = lib.mkMerge [
          {
            name = "rockchip/rk3588s-fydetab-duo.dtb";
          }
          (lib.mkIf config.hardware.fydetab.duo.enablePanthor {
            overlays = [
              {
                name = "fydetab-panthor-gpu";
                dtsText = ''
                  /dts-v1/;
                  /plugin/;

                  #include <dt-bindings/clock/rk3588-cru.h>
                  #include <dt-bindings/interrupt-controller/arm-gic.h>
                  #include <dt-bindings/power/rk3588-power.h>

                  / {
                    compatible = "rockchip,rk3588s-tablet-12c-linux";
                    fragment@0 {
                      target = <&gpu>;
                      __overlay__ {
                        status = "disabled";
                      };
                    };

                    fragment@1 {
                      target = <&gpu_panthor>;
                      __overlay__ {
                        status = "okay";
                        mali-supply = <&vdd_gpu_s0>;
                      };
                    };
                  };
                '';
              }
            ];
          })
        ];
        rockchip = {
          rk3588.enable = true;
          platformFirmware = pkgs.callPackage ./u-boot.nix { };
        };
      }
      (lib.mkIf config.networking.wireless.iwd.enable {
        firmware = [
          # Only iwd is supported by the interface
          ap6275pFirmware
        ];
      })
      (lib.mkIf config.hardware.graphics.enable {
        firmware = [
          (pkgs.callPackage ./mali-g610.nix { })
        ];
      })
      (lib.mkIf config.hardware.sensor.iio.enable {
        firmware = [
          (pkgs.callPackage ./himax.nix { })
        ];
      })
    ];

    systemd.services.bluetooth-fydetab = lib.mkIf config.hardware.bluetooth.enable {
      description = "FydeTab Duo Bluetooth fix";
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "simple";
      script = ''
        ${lib.getExe' pkgs.util-linux "rfkill"} block 0
        ${lib.getExe' pkgs.util-linux "rfkill"} block bluetooth
        sleep 2
        ${lib.getExe' pkgs.util-linux "rfkill"} unblock 0
        ${lib.getExe' pkgs.util-linux "rfkill"} unblock bluetooth

        sleep 1

        ${
          lib.getExe (pkgs.callPackage ./brcm-patchram.nix { })
        } --enable_hci --no2bytes --use_baudrate_for_download --tosleep 200000 --baudrate 1500000 --patchram ${ap6275pFirmware}/lib/firmware/ap6275p/BCM4362A2.hcd /dev/ttyS9
      '';
    };

    services.udev = {
      extraHwdb = ''
        # Fydetab
        evdev:input:b0018v0000p0000e0000*
          EVDEV_ABS_00=::265
          EVDEV_ABS_01=::166
      '';
      extraRules = ''
        SUBSYSTEM=="iio" ATTR{name}=="lis2dw12" ENV{ACCEL_MOUNT_MATRIX}="1,0,0;0,-1,0;0,0,1"
        SUBSYSTEM=="input", ENV{ID_INPUT_TABLET}=="1", ENV{LIBINPUT_CALIBRATION_MATRIX}="0 1 0 -1 0 1 0 0 1"
      '';
    };
  };
}
