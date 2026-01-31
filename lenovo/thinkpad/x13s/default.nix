{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (config.boot.kernelPackages) kernel;

  dtbName = "sc8280xp-lenovo-thinkpad-x13s.dtb";
  dtb = "${kernel}/dtbs/qcom/${dtbName}";
  # Version the dtb based on the kernel
  dtbEfiPath = "dtbs/x13s-${kernel.version}.dtb";
  
  cfg = config.hardware.lenovo.x13s;

  inherit (lib) mkDefault;
in
{
  imports = [
    ../.
    ../../../common/pc/laptop
  ];

  options.hardware.lenovo.x13s = {
    wifiMac = lib.mkOption {
      type = lib.types.nullOr lib.types.strMatching "([0-9a-f]{2}(:[0-9a-f]{2}){5})";
      description = ''
        WiFi MAC address to set on boot. When not set a random mac
        address is assigned. Expects lowercase.
      '';
      default = null;
    };

    bluetoothMac = lib.mkOption {
      type = lib.types.nullOr lib.types.strMatching "([0-9A-F]{2}(:[0-9A-F]{2}){5})";
      description = ''
        Bluetooth MAC address to set on boot. If null, the mac is
        generated using /etc/machine-id to seed the random generator.
        When not set, bluetooth.service fails to start. Expects
        upper case.
      '';
      default = "";
    };
  };

  config = {
    boot = {
      loader.systemd-boot.extraFiles = {
        "${dtbEfiPath}" = dtb;
      };

      kernelParams = mkDefault [
        # needed to boot
        "dtb=${dtbEfiPath}"

        # jhovold recommended
        "clk_ignore_unused"
        "pd_ignore_unused"
        "arm64.nopauth"
      ];

      kernelModules = mkDefault [
        "nvme"
        "phy-qcom-qmp-pcie"
        "pcie-qcom"

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

    hardware.enableRedistributableFirmware = mkDefault true;

    systemd.services.bluetooth-x13s-mac = lib.mkIf (cfg.bluetoothMac != null) {
      wantedBy = [ "multi-user.target" ];
      before = [ "bluetooth.service" ];
      requiredBy = [ "bluetooth.service" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.util-linux}/bin/script -q -c '${pkgs.bluez}/bin/btmgmt --index 0 public-addr ${cfg.bluetoothMac}'";
      };
    };

    # https://github.com/jhovold/linux/wiki/X13s#modem
    networking.modemmanager.fccUnlockScripts = [

      {
        id = "105b:e0c3";
        path = "${pkgs.modemmanager}/share/ModemManager/fcc-unlock.available.d/105b";
      }
    ];

    # https://github.com/jhovold/linux/wiki/X13s#camera
    services.udev.extraRules = lib.strings.concatLines (
      [
        ''
          ACTION=="add", SUBSYSTEM=="dma_heap", KERNEL=="linux,cma", GROUP="video", MODE="0660"
          ACTION=="add", SUBSYSTEM=="dma_heap", KERNEL=="system", GROUP="video", MODE="0660"
        ''
      ]
      ++ (
        if cfg.wifiMac != null then
          [
            ''
              ACTION=="add", SUBSYSTEM=="net", KERNELS=="0006:01:00.0", RUN+="${pkgs.iproute2}/bin/ip link set dev $name address ${cfg.wifiMac}"
            ''
          ]
        else
          [ ]
      )
    );
  };
}
