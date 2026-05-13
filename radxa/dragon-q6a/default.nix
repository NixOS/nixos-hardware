{
  lib,
  pkgs,
  config,
  ...
}:
let
  alsa-ucm-conf-patches = pkgs.fetchFromGitHub {
    owner = "radxa-pkg";
    repo = "alsa-ucm-conf";
    tag = "1.2.14-1radxa2";
    hash = "sha256-9y+0GxJ/CCA9J0gnRPl+EHxNnQNuKiNceB0dfilPeT4=";
  };
  alsa-ucm-conf-patched = pkgs.alsa-ucm-conf.overrideAttrs (oldAttrs: {
    # https://github.com/radxa-pkg/alsa-ucm-conf/blob/main/debian/patches/series
    patches = (oldAttrs.patches or [ ]) ++ [
      "${alsa-ucm-conf-patches}/debian/patches/radxa/0001-add-radxa-dragon-q6a-support.patch"
      "${alsa-ucm-conf-patches}/debian/patches/radxa/0002-fix-radxa-dragon-q6a-config.patch"
      "${alsa-ucm-conf-patches}/debian/patches/radxa/0003-ucm2-Qualcomm-qcs6490-Add-DMI-match-for-Radxa-Dragon.patch"
    ];
  });
in
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

    systemd.tpm2.enable = false;
    environment.variables.ALSA_CONFIG_UCM2 = "${alsa-ucm-conf-patched}/share/alsa/ucm2";
  };
}
