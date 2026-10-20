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

    stateVersion = lib.mkOption {
      type = lib.types.int;
      description = ''
        State version for this module. Allows smooth migrations
        between updates.
      '';
      default = 0;
    };
  };

  config = lib.mkMerge ([

    # State versioning
    (lib.mkIf (cfg.stateVersion == 0) {
      warnings = [
        "hardware.lenovo.x13s.stateVersion is not set; using legacy behavior (1). Set it to 2 to derive Wi-Fi and Bluetooth MAC addresses from /etc/machine-id. Note: this changes the Bluetooth MAC, so paired devices must be re-paired or the MAC set menually. Set it to 1 to keep the current behavior and silence this warning."
      ];
    })

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
    (lib.mkIf (cfg.wifiMAC == null && cfg.stateVersion > 1) {
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
    (lib.mkIf (config.hardware.bluetooth.enable && cfg.stateVersion <= 1) {
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
            echo 'Generating Bluetooth MAC'
            # we might be able to use the system serial number but, if we lost machine-id
            # the system has probably lost the bluetooth device keys anyway
            SEED=$(( $(cat /etc/machine-id | head -c 128 | sed -e 's/[^0-9]//g;s/^0*//') ))

            # https://datatracker.ietf.org/doc/html/rfc7042#section-2.1
            # > Two bits within the initial octet of an EUI-48 have special
            # > significance in MAC addresses: the Group bit (01) and the Local bit
            # > (02).  OUIs and longer MAC prefixes are assigned with the Local bit
            # > zero and the Group bit unspecified.  Multicast identifiers may be
            # > constructed by turning on the Group bit, and unicast identifiers may
            # > be constructed by leaving the Group bit zero.
            #
            # First, and only argument is for passing a file to seed RANDOM.
            # recommend using `/etc/machine-id` to pin the MAC address if needed.
            
            BLUETOOTH_MAC="$(RANDOM=$SEED ; printf '%X%X:%02X:%02X:%02X:%02X:%02X' \
              $[RANDOM%16] $[((RANDOM%4)+1)*4-2] \
              $[RANDOM%256] \
              $[RANDOM%256] \
              $[RANDOM%256] \
              $[RANDOM%256] \
              $[RANDOM%256])"
          fi

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
    (lib.mkIf (config.hardware.bluetooth.enable && cfg.stateVersion > 1) {
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
          "pwrseq-qcom-wcn"
          "pci-pwrctrl-pwrseq"

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
        ];
      };
    }

    # boot loader needs to know about and handle the dtb for the system. systemd-boot handles this
    # automagically when hardware.deviceTree.enable is true since 24.11
    (lib.mkIf
      (
        config.boot.loader.systemd-boot.enable
        && deviceTree.enable
        && (lib.versionOlder config.system.stateVersion "24.11")
      )
      {
        boot = {
          loader.systemd-boot.extraFiles = {
            "dtbs/${deviceTree.kernelPackage.version}" = "${deviceTree.package}";
          };

          kernelParams = [ "dtb=dtbs/${deviceTree.kernelPackage.version}/${deviceTree.name}" ];
        };
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
            devicetree dtbs/${deviceTree.kernelPackage.version}/${deviceTree.name}
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
