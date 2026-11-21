{
  config,
  lib,
  pkgs,
  ...
}:

let
  deviceTree = config.hardware.deviceTree;
  modemmanager = config.networking.modemmanager;

  # Based on RFC 9542 and SLAP.
  macFrom =
    salt:
    lib.throwIfNot (builtins.match "[a-z0-9-]+" salt != null)
      "macFrom: salt must match [a-z0-9-]+, got ${builtins.toJSON salt}"
      (
        pkgs.writeShellScript "mac-from-${salt}" ''
          hash=$(printf '%s:%s' "$(< /etc/machine-id)" "${salt}" \
            | ${pkgs.coreutils}/bin/sha256sum)

          printf '%s:%s:%s:%s:%s:%s\n' \
            "''${hash:0:1}2" "''${hash:2:2}" \
            "''${hash:4:2}" "''${hash:6:2}" \
            "''${hash:8:2}" "''${hash:10:2}"
        ''
      );

  cfg = config.hardware.lenovo.x13s;
in
{
  imports = [
    ../.
    ../../../common/pc/laptop
    ./patches.nix
  ];

  options.hardware.lenovo.x13s = {
    wifiMAC = lib.mkOption {
      type = lib.types.nullOr (lib.types.strMatching "([0-9a-f]{2}(:[0-9a-f]{2}){5}|)");
      description = ''
        Wi-Fi MAC address to set on boot. When not set a random MAC
        address is assigned. Expects lowercase. Set to an empty string
        to have the system automatically generate the MAC address.
      '';
      default = null;
    };

    bluetoothMAC = lib.mkOption {
      type = lib.types.nullOr (lib.types.strMatching "([0-9A-F]{2}(:[0-9A-F]{2}){5})");
      description = ''
        Bluetooth MAC address to set on boot. If null, the MAC is
        generated using /etc/machine-id to seed the random generator.
        When not set, bluetooth.service fails to start. Expects
        upper case.
      '';
      default = null;
    };
  };

  config = lib.mkMerge ([

    # Wi-Fi
    (lib.mkIf (cfg.wifiMAC != null && cfg.wifiMAC != "") {
      # https://github.com/jhovold/linux/wiki/X13s#wi-fi
      services.udev.extraRules = builtins.concatStringsSep ", " [
        ''ACTION=="add"''
        ''SUBSYSTEM=="net"''
        ''KERNELS=="0006:01:00.0"''
        ''RUN+="${pkgs.iproute2}/bin/ip link set dev $name address ${cfg.wifiMAC}"''
      ];
    })
    (lib.mkIf (cfg.wifiMAC == null) {
      # https://github.com/jhovold/linux/wiki/X13s#wi-fi
      services.udev.extraRules = builtins.concatStringsSep ", " [
        ''ACTION=="add"''
        ''SUBSYSTEM=="net"''
        ''KERNELS=="0006:01:00.0"''
        ''PROGRAM="${macFrom "wifi"}"''
        ''RUN+="${pkgs.iproute2}/bin/ip link set dev $name address %c"''
      ];
    })

    # Bluetooth
    (lib.mkIf config.hardware.bluetooth.enable {
      # https://github.com/jhovold/linux/wiki/X13s#bluetooth
      systemd.services.bluetooth-x13s-mac = {
        wantedBy = [ "bluetooth.target" ];
        before = [ "bluetooth.service" ];
        requiredBy = [ "bluetooth.service" ];
        after = [ "sys-subsystem-bluetooth-devices-hci0.device" ];
        bindsTo = [ "sys-subsystem-bluetooth-devices-hci0.device" ];
        stopIfChanged = false;
        restartIfChanged = false;

        script = ''
          BLUETOOTH_MAC="${lib.optionalString (cfg.bluetoothMAC != null) cfg.bluetoothMAC}"

          if [ "$BLUETOOTH_MAC" = "" ] ; then
            BLUETOOTH_MAC="$(${macFrom "bluetooth"})"
          fi
          BLUETOOTH_MAC="''${BLUETOOTH_MAC^^}"

          echo "Waiting for Adapter"

          # Listen to the hardware setup and wait for the adapter to
          # finish receiving its firmware, and finish loading
          mkfifo /tmp/btmon.log
          stdbuf -oL ${config.hardware.bluetooth.package}/bin/btmon --mgmt --kernel >> /tmp/btmon.log &
          BTPID=$!
          grep -q -m 1 "Unconfigured Index Ad" /tmp/btmon.log || true
          kill $BTPID 2>/dev/null

          echo "Assigning MAC: $BLUETOOTH_MAC"

          ${config.hardware.bluetooth.package}/bin/btmgmt --index 0 public-addr $BLUETOOTH_MAC
        '';

        serviceConfig = {
          Type = "oneshot";
          PrivateTmp = "true";
          RemainAfterExit = true;
          TimeoutSec = "1m";
        };
      };
    })

    # Modem
    (lib.mkIf (modemmanager.enable) {
      # https://github.com/jhovold/linux/wiki/X13s#modem
      networking.modemmanager.fccUnlockScripts = [
        {
          id = "105b:e0c3";
          path = "${modemmanager.package}/share/ModemManager/fcc-unlock.available.d/105b";
        }
      ];
    })

    # Camera
    {
      # https://github.com/jhovold/linux/wiki/X13s#camera
      services.udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="dma_heap", KERNEL=="linux,cma", GROUP="video", MODE="0660"
        ACTION=="add", SUBSYSTEM=="dma_heap", KERNEL=="system", GROUP="video", MODE="0660"
      '';
    }

    # Minimum requirements for a running system
    {
      hardware = {
        enableRedistributableFirmware = lib.mkDefault true;
        deviceTree = {
          enable = true;
          filter = lib.mkDefault "sc8280xp-lenovo-thinkpad-x13s*.dtb";
          name = lib.mkDefault "qcom/sc8280xp-lenovo-thinkpad-x13s.dtb";
        };
      };

      boot = {
        # https://github.com/jhovold/linux/wiki/X13s#kernel-command-line
        kernelParams = [
          "clk_ignore_unused"
          "pd_ignore_unused"
          "arm64.nopauth"
          # "efi=noruntime"
        ];

        initrd.availableKernelModules = [
          "nvme"
          "phy-qcom-qmp-pcie"

          "i2c-core"
          "i2c-hid"
          "i2c-hid-of"
          "i2c-qcom-geni"

          "leds_qcom_lpg"
          "pwm_bl"
          "qrtr"
          "pmic_glink_altmode"
          "gpio_sbu_mux"
          "phy-qcom-qmp-combo"
          "gpucc_sc8280xp"
          "dispcc_sc8280xp"
          "phy_qcom_edp"
          "panel-edp"
        ]
        ++ lib.optionals (lib.versionOlder config.boot.kernelPackages.kernel.version "7") [ "msm" ]
        ++ lib.optionals (lib.versionAtLeast config.boot.kernelPackages.kernel.version "7") [
          "pwrseq-qcom-wcn"
          "pci-pwrctrl-pwrseq"
        ];
      };
    }

    # enable the light on the top cover; showing suspend state
    ({
      hardware.deviceTree.overlays = [
        {
          name = "x13s-ec-i2c8";
          filter = "*x13s*.dtb";
          dtsText = ''
            	      /dts-v1/;
            	      /plugin/;

            	      / {
            		compatible = "lenovo,thinkpad-x13s";

            		fragment@0 {
            		  target-path = "/soc@0/pinctrl@f100000";
            		  __overlay__ {
            		    i2c8_default: i2c8-default-state {
            		      pins = "gpio43", "gpio44";
            		      function = "qup8";
            		      drive-strength = <16>;
            		      bias-disable;
            		    };
            		  };
            		};

            		fragment@1 {
            		  target-path = "/soc@0/geniqup@ac0000/i2c@a80000";
            		  __overlay__ {
            		    status = "okay";
            		    clock-frequency = <400000>;
            		    pinctrl-names = "default";
            		    pinctrl-0 = <&i2c8_default>;
            		  };
            		};
            	      };
            	    '';
        }
      ];

      powerManagement = {
        powerDownCommands = ''
          	    # Modern Standby Lowest Power State Entry: notify EC to pulse/breathe LED
          	    BUS=$(basename $(ls -d /sys/devices/platform/soc@0/ac0000.geniqup/a80000.i2c/i2c-* 2>/dev/null | head -n 1) | sed "s/i2c-//")
          	    if [ -n "$BUS" ]; then
          	      ${pkgs.i2c-tools}/bin/i2ctransfer -y "$BUS" w5@0x28 0x03 0x80 0x00 0x01 0x55 || true
          	    fi
          	  '';
        resumeCommands = ''
          	    # Modern Standby Lowest Power State Exit: notify EC to restore normal solid LED
          	    BUS=$(basename $(ls -d /sys/devices/platform/soc@0/ac0000.geniqup/a80000.i2c/i2c-* 2>/dev/null | head -n 1) | sed "s/i2c-//")
          	    if [ -n "$BUS" ]; then
          	      ${pkgs.i2c-tools}/bin/i2ctransfer -y "$BUS" w5@0x28 0x03 0x80 0x00 0x01 0xAA || true
          	    fi
          	  '';
      };
    })

    # boot loader needs to know about and handle the dtb for the system. systemd-boot handles this
    # automagically when hardware.deviceTree.enable is true since 24.11
    (lib.mkIf
      (
        config.boot.loader.systemd-boot.enable
        && deviceTree.enable
        && (lib.versionOlder config.system.nixos.release "24.11")
      )
      {
        assertions =
          let
            dtbParams = lib.filter (lib.hasPrefix "dtb=") config.boot.kernelParams;
          in
          [
            {
              assertion = lib.length dtbParams == 1;
              message = ''
                The kernelParam `dtb=` is now handled by the x13s module. Remove it from your configuration to continue.
              '';
            }
          ];

        boot = {
          loader.systemd-boot.extraFiles = {
            "dtbs/${deviceTree.kernelPackage.version}" = "${deviceTree.package}";
          };

          kernelParams = [ "dtb=dtbs/${deviceTree.kernelPackage.version}/${deviceTree.name}" ];
        };
      }
    )

    (lib.mkIf
      (
        config.boot.loader.systemd-boot.enable
        && deviceTree.enable
        && (lib.versionAtLeast config.system.nixos.release "24.11")
      )
      {
        assertions =
          let
            dtbParams = lib.filter (lib.hasPrefix "dtb=") config.boot.kernelParams;
          in
          [
            {
              assertion = lib.length dtbParams == 0;
              message = ''
                The devicetree is handled by the systemd-boot module. Remove the `dtb=` kernelParam from your configuration to continue.
              '';
            }
          ];
      }
    )

    # GRUB does not handle device tree yet
    (lib.mkIf (config.boot.loader.grub.enable) {
      warnings = lib.optional (
        !config.boot.loader.grub.efiSupport
      ) "grub.efiSupport is required for Lenovo Thinkpad x13s";
      boot = {
        loader.grub = {
          extraPerEntryConfig = ''
            devicetree /dtbs/${deviceTree.kernelPackage.version}/${deviceTree.name}
          '';
          extraFiles =
            let
              deviceTrees = lib.map (lib.removePrefix "${deviceTree.package}/") (
                lib.filesystem.listFilesRecursive "${deviceTree.package}"
              );
            in
            lib.listToAttrs (
              lib.map (dt: {
                # It's alright to throw away the context here. We still have context through the value
                # and the context is not needed to generate paths based on filenames in the device tree
                name = builtins.unsafeDiscardStringContext "dtbs/${deviceTree.kernelPackage.version}/${dt}";
                value = "${deviceTree.package}/${dt}";
              }) deviceTrees
            );
        };
      };
    })

  ]);
}
