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

  hardware = {
    deviceTree.name = "rockchip/rk3588s-fydetab-duo.dtb";
    rockchip = {
      rk3588.enable = true;
      platformFirmware = pkgs.callPackage ./u-boot.nix { };
    };
    firmware = lib.mkMerge [
      # Only iwd is supported by the interface
      (lib.mkIf config.networking.wireless.iwd.enable ap6275pFirmware)
      (lib.mkIf config.hardware.graphics.enable (pkgs.callPackage ./mali-g610.nix { }))
    ];
  };

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
}
