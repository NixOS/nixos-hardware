{
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./cross.nix
  ];

  nixpkgs.overlays = [
    (import ./overlay.nix)
  ];

  nixpkgs.hostPlatform.system = "aarch64-linux";

  boot = {
    kernelPackages = lib.mkDefault (pkgs.linuxPackagesFor pkgs.qrb2210-linux);

    kernelParams = lib.mkDefault [
      "console=ttyMSM0,115200n8"
      "clk_ignore_unused"
      "pd_ignore_unused"
      "deferred_probe_timeout=30"
    ];

    loader = {
      grub.enable = lib.mkDefault false;
      generic-extlinux-compatible = {
        enable = lib.mkDefault true;
        useGenerationDeviceTree = true;
      };
    };

    initrd = {
      availableKernelModules = lib.mkForce {
        mmc_block = true;
        phy_qcom_qusb2 = true;
        sdhci = true;
        sdhci_msm = true;
        sdhci_pltfm = true;
      };
      includeDefaultModules = lib.mkForce false;
      extraFiles = {
        "lib/firmware/qcom/a702_sqe.fw".source =
          "${pkgs.qrb2210-firmware}/lib/firmware/qcom/a702_sqe.fw";
        "lib/firmware/qcom/qcm2290/a702_zap.mbn".source =
          "${pkgs.qrb2210-firmware}/lib/firmware/qcom/qcm2290/a702_zap.mbn";
      };
    };

    kernelModules = [
      "ath10k_snoc"
      "btqca"
      "hci_uart"
      "i2c_qcom_geni"
      "leds_qcom_lpg"
      "qcom_q6v5_pas"
      "qcom_rmtfs_mem"
      "qcom_wcnss_pil"
      "qrtr"
    ];
  };

  hardware = {
    deviceTree.enable = true;
    enableRedistributableFirmware = lib.mkDefault true;
    firmware = [
      pkgs.qrb2210-firmware
    ];
  };

  environment.systemPackages = [
    pkgs.qrb2210-boot
    pkgs.qrb2210-qcombin
    pkgs.qrb2210-uboot
  ];
}

