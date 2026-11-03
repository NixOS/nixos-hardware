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
    ./audio.nix
    (lib.mkRemovedOptionModule [
      "hardware"
      "fydetab"
      "duo"
      "enablePanthor"
    ] "The 6.12 kernel device tree enables Panthor by default.")
  ];

  config = {
    boot = lib.mkMerge [
      {
        initrd.includeDefaultModules = false;
        # The rest of the display stack is built in. Stage 1 needs the panel for Plymouth and passphrase prompts.
        initrd.kernelModules = [ "panel-simple" ];
        # The tablet has no TPM and the kernel has no ACPI for tpm-crb.
        initrd.systemd.tpm2.enable = lib.mkDefault false;
        kernelPackages = pkgs.callPackage ./kernel.nix { };
        extraModprobeConfig = ''
          options bcmdhd firmware_path=${ap6275pFirmware}/lib/firmware/ap6275p/fw_bcm43752a2_pcie_ag.bin nvram_path=${ap6275pFirmware}/lib/firmware/ap6275p/nvram_ap6275p.txt config_path=${ap6275pFirmware}/lib/firmware/ap6275p/config_bcm43752a2_pcie_ag.txt
        '';
        kernelParams = [
          "console=ttyFIQ0"
          "console=tty1"
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
      (lib.mkIf config.boot.plymouth.enable {
        # ttyFIQ0 is always a console. With a serial console, Plymouth shows only text.
        kernelParams = [ "plymouth.ignore-serial-consoles" ];
      })
      (lib.mkIf config.hardware.wirelessRegulatoryDatabase {
        # cfg80211 is built in and reads the database before the root filesystem is mounted.
        initrd.extraFirmwarePaths = [
          "regulatory.db"
          "regulatory.db.p7s"
        ];
      })
    ];

    hardware = lib.mkMerge [
      {
        deviceTree = {
          name = "rockchip/rk3588s-fydetab_duo.dtb";
          overlays = [
            {
              # The vendor MPP nodes share VPU121 with the mainline Hantro driver and take its IRQ.
              # Nixpkgs has no MPP userspace, but Hantro works with V4L2 stateless decoding.
              name = "fydetab-duo-hantro";
              dtsText = ''
                /dts-v1/;
                /plugin/;

                / {
                  compatible = "rockchip,rk3588s-tablet-fydetab-linux";
                };

                &vepu {
                  status = "disabled";
                };

                &vdpu {
                  status = "disabled";
                };
              '';
            }
          ];
        };
        rockchip = {
          rk3588.enable = true;
          platformFirmware = pkgs.callPackage ./u-boot.nix { };
        };
        # Panthor loads the Mali CSF firmware from linux-firmware.
        enableRedistributableFirmware = lib.mkDefault true;
        wirelessRegulatoryDatabase = lib.mkDefault true;
        firmware = [
          # bcmdhd keeps only "ap6275p/<file>" of the module paths and loads it with request_firmware.
          ap6275pFirmware
          (pkgs.callPackage ./himax.nix { })
        ];
      }
    ];

    system.build.ubootResource = pkgs.callPackage ./u-boot-resource.nix {
      inherit (config.hardware.rockchip) platformFirmware;
    };

    # bcmdhd creates wlan0 only after it loads its firmware. If iwd starts first, it gives up on the busy interface.
    systemd.services.iwd = lib.mkIf config.networking.wireless.iwd.enable {
      wants = [ "sys-subsystem-net-devices-wlan0.device" ];
      after = [ "sys-subsystem-net-devices-wlan0.device" ];
    };

    # ModemManager only starts through D-Bus activation, and nothing asks for it, so the built-in LTE modem stays unused.
    systemd.services.ModemManager.wantedBy = lib.mkIf config.networking.modemmanager.enable [
      "multi-user.target"
    ];

    systemd.services.bluetooth-fydetab = lib.mkIf config.hardware.bluetooth.enable {
      description = "FydeTab Duo Bluetooth fix";
      wantedBy = [ "multi-user.target" ];
      bindsTo = [ "dev-ttyS9.device" ];
      after = [ "dev-ttyS9.device" ];
      before = [ "bluetooth.service" ];
      unitConfig.StartLimitIntervalSec = 0;
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        RestartSec = "3s";
      };
      script = ''
        ${lib.getExe' pkgs.util-linux "rfkill"} block bluetooth
        sleep 2
        ${lib.getExe' pkgs.util-linux "rfkill"} unblock bluetooth

        sleep 1

        ${
          lib.getExe (pkgs.callPackage ./brcm-patchram.nix { })
        } --enable_hci --no2bytes --use_baudrate_for_download --tosleep 200000 --baudrate 1500000 --patchram ${ap6275pFirmware}/lib/firmware/ap6275p/BCM4362A2.hcd /dev/ttyS9
      '';
    };

    services.udev = {
      # Resolution is in units per mm. The panel is 166 x 266 mm, and the stylus range is 10 times the touch range.
      extraHwdb = ''
        evdev:name:himax-touchscreen:*
          EVDEV_ABS_00=::10
          EVDEV_ABS_01=::10
          EVDEV_ABS_35=::10
          EVDEV_ABS_36=::10

        evdev:name:himax-stylus:*
          EVDEV_ABS_00=::96
          EVDEV_ABS_01=::96
      '';
      extraRules = ''
        SUBSYSTEM=="iio" ATTR{name}=="lis2dw12" ENV{ACCEL_MOUNT_MATRIX}="1,0,0;0,-1,0;0,0,1"
      '';
    };
  };
}
