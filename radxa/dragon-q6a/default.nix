{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ../.
  ];

  config = {
    hardware = {
      radxa.enable = true;
    };

    boot = {
      # We need a out-of-tree kernel for Dragon Q6A, otherwise important hardware such as NVME won't work.
      kernelPackages = lib.mkDefault (pkgs.linuxPackagesFor (import ./kernel.nix { inherit lib pkgs; }));
      loader = {
        systemd-boot = {
          enable = lib.mkDefault true;
          installDeviceTree = true;
        };
        efi.canTouchEfiVariables = false;
      };
      kernelParams = [
        "console=ttyMSM0,115200n8"
        "earlycon"
        "keep_bootcon"
      ];

      initrd = {
        availableKernelModules = [
          "usb_storage"
          "nvme"
          "xhci_hcd"
        ];
      };
    };

    console.earlySetup = lib.mkDefault true;

    hardware = {
      firmware = with pkgs; [
        linux-firmware
      ];
      deviceTree = {
        enable = true;
        name = "qcom/qcs6490-radxa-dragon-q6a.dtb";
      };
    };
  };
}
