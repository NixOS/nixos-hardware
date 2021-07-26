{ lib, pkgs, ... }: {
  imports = [ ../../../common/cpu/intel ../../../common/pc/laptop ];

  # Includes the Wi-Fi and Bluetooth firmware for the QCA6390.
  hardware.enableRedistributableFirmware = true;

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_5_12;
  # TODO: upstream this to NixOS
  boot.kernelPatches = [{
    name = "enable-qca6390-bluetooth";
    patch = null;
    extraConfig = ''
      BT_QCA m
      BT_HCIUART m
      BT_HCIUART_QCA y
      BT_HCIUART_SERDEV y
      SERIAL_DEV_BUS y
      SERIAL_DEV_CTRL_TTYPORT y
    '';
  }];
  boot.kernelModules = [ "btqca" "hci_qca" "hci_uart" ];

  # Touchpad goes over i2c.
  # Without this we get errors in dmesg on boot and hangs when shutting down.
  boot.blacklistedKernelModules = [ "psmouse" ];

  # Allows for updating firmware via `fwupdmgr`.
  services.fwupd.enable = true;
}
