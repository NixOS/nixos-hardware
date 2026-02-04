{
  config,
  lib,
  pkgs,
  ...
}:

let
  deviceTree = config.hardware.deviceTree;
  modemmanager = config.networking.modemmanager;

  cfg = config.hardware.lenovo.x13s;
in
{
  imports = [
    ../.
    ../../../common/pc/laptop
  ];

  options.hardware.lenovo.x13s = {
    wifiMac = lib.mkOption {
      type = lib.types.nullOr (lib.types.strMatching "([0-9a-f]{2}(:[0-9a-f]{2}){5})");
      description = ''
        WiFi MAC address to set on boot. When not set a random mac
        address is assigned. Expects lowercase.
      '';
      default = null;
    };

    bluetoothMac = lib.mkOption {
      type = lib.types.nullOr (lib.types.strMatching "([0-9A-F]{2}(:[0-9A-F]{2}){5})");
      description = ''
        Bluetooth MAC address to set on boot. If null, the mac is
        generated using /etc/machine-id to seed the random generator.
        When not set, bluetooth.service fails to start. Expects
        upper case.
      '';
      default = null;
    };
  };

  config = lib.mkMerge ([

    # WiFi
    (lib.mkIf (cfg.wifiMac != null) {
      # https://github.com/jhovold/linux/wiki/X13s#wi-fi
      services.udev.extraRules = builtins.concatStringsSep ", " [
        ''ACTION=="add"''
        ''SUBSYSTEM=="net"''
        ''KERNELS=="0006:01:00.0"''
        ''RUN+="${pkgs.iproute2}/bin/ip link set dev $name address ${cfg.wifiMac}"''
      ];
    })

    # Bluetooth
    (lib.mkIf (config.hardware.bluetooth.enable) {
      # https://github.com/jhovold/linux/wiki/X13s#bluetooth
      systemd.services.bluetooth-x13s-mac = {
        wantedBy = [ "multi-user.target" ];
        before = [ "bluetooth.service" ];
        requiredBy = [ "bluetooth.service" ];
        stopIfChanged = false;
        restartIfChanged = false;

        script = ''
          BLUETOOTH_MAC="${if cfg.bluetoothMac == null then "" else cfg.bluetoothMac}"

          if [ "$BLUETOOTH_MAC" = "" ] ; then
            echo 'generating bluetooth mac'
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
            # recommend using `/etc/machine-id` to pin the mac address if needed.
            
            BLUETOOTH_MAC="$(RANDOM=$SEED ; printf '%X%X:%02X:%02X:%02X:%02X:%02X' \
              $[RANDOM%16] $[((RANDOM%4)+1)*4-2] \
              $[RANDOM%256] \
              $[RANDOM%256] \
              $[RANDOM%256] \
              $[RANDOM%256] \
              $[RANDOM%256])"
          fi

          while ! [ -d /sys/class/bluetooth ] ; do
            echo "waiting for bluetooth"
            sleep 5
          done

          echo "assigning mac: $BLUETOOTH_MAC"
          yes | ${config.hardware.bluetooth.package}/bin/btmgmt --index 0 public-addr $BLUETOOTH_MAC
        '';

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
      };

      systemd.services.bluetooth = {
        unitConfig = {
          ConditionPathIsDirectory = "";
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

        initrd.kernelModules = [
          "nvme"
          "phy-qcom-qmp-pcie"
          # "pcie-qcom" # this is no longer a module

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
          "msm"
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

          kernelParams = [
            "dtb=dtbs/${deviceTree.kernelPackage.version}/${deviceTree.name}"
          ];
        };
      }
    )

    # grub does not handle device tree yet
    (lib.mkIf (config.boot.loader.grub.enable) {
      warnings = lib.optional (!config.boot.loader.grub.efiSupport) "grub.efiSupport is required for Lenovo Thinkpad x13s";
      boot = {
        loader.grub = {
          extraPerEntryConfig = ''
            devicetree dtbs/${deviceTree.kernelPackage.version}/${deviceTree.name}
          '';
          extraFiles = let
            deviceTrees = lib.map (lib.removePrefix "${deviceTree.package}/") (lib.filesystem.listFilesRecursive "${deviceTree.package}");
          in lib.listToAttrs (lib.map (dt: {
              name = builtins.unsafeDiscardStringContext "dtbs/${deviceTree.kernelPackage.version}/${dt}";
              value = "${deviceTree.package}/${dt}";
            }) deviceTrees);
        };
      };
    })

  ]);
}
