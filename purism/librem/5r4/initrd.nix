{ config, lib, ... }:
lib.mkIf config.hardware.librem5.customInitrdModules {
  boot.initrd = {
    kernelModules = [
      "bq25890_charger"
      "dwc3"
      "imx_dcss"
      "imx_sdma"
      "mtdblock"
      "ofpart"
      "phy_fsl_imx8mq_usb"
      "snvs_pwrkey"
      "spi_nor"
      "tps6598x"
      "xhci_hcd"
      "usbcore"
      "usb-storage"
      "uas"
      "xhci_plat_hcd"
    ];
    # Not all default modules (e.g. SATA ones) are present in Librem 5 kernel fork
    includeDefaultModules = false;
    availableKernelModules = [
      "ahci"

      "sd_mod"
      "sr_mod"

      "mmc_block"

      "uhci_hcd"
      "ehci_hcd"
      "ehci_pci"
      "ohci_hcd"
      "ohci_pci"
      "xhci_pci"
      "usbhid"
      "hid_generic"
      "hid_lenovo"
      "hid_apple"
      "hid_roccat"
      "hid_logitech_hidpp"
      "hid_logitech_dj"
      "hid_microsoft"
      "hid_cherry"

      "bq25890_charger"
      "dwc3"
      "imx_dcss"
      "imx_sdma"
      "mtdblock"
      "ofpart"
      "phy_fsl_imx8mq_usb"
      "snvs_pwrkey"
      "spi_nor"
      "tps6598x"
      "xhci_hcd"
      "usbcore"
      "usb-storage"
      "uas"
      "xhci_plat_hcd"
    ];
  };
}
