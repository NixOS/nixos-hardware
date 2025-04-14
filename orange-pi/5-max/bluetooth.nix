{ config, pkgs, lib, ... }:
let
  cfg = config.hardware.orange-pi."5-max".bluetooth;
  bcmdhd_sdio = config.boot.kernelPackages.callPackage ./kernel/bcmdhd_sdio.nix { };
  brcm_patchram_plus = pkgs.callPackage ./brcm_patchram_plus.nix { };
  orangepi-firmware = pkgs.callPackage ./orangepi-firmware.nix { };
in
{
  options.hardware = {
    orange-pi."5-max".bluetooth = {
      enable = lib.mkEnableOption "configuration for bluetooth" // {
        default = config.hardware.bluetooth.enable;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      kernelModules = [ "bcmdhd_sdio" ];
      blacklistedKernelModules = [ "bcmdhd" "dhd_static_buf" ];
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

    systemd.services."ap611s-bluetooth" = {
      enable = lib.mkDefault config.hardware.bluetooth.enable;
      description = "Bluetooth loading for AP611S";
      after = [ "bluetooth.target" ];
      serviceConfig = {
        Type = "forking";
        ExecStart = "${brcm_patchram_plus}/bin/brcm_patchram_plus --bd_addr_rand --enable_hci --no2bytes --use_baudrate_for_download --tosleep 200000 --baudrate 1500000 --patchram ${orangepi-firmware}/lib/firmware/SYN43711A0.hcd /dev/ttyS7 &";
        TimeoutSec = "0s";
        RemainAfterExit = true;
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
