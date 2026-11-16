{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware.nvidia.dgx-station;
in
{
  imports = [
    ../../common/gpu/nvidia/blackwell
    ../../common/pc
    ../../common/pc/ssd
  ];

  options.hardware.nvidia.dgx-station = {
    kernel64kPages = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    tuning = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = {
    nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

    boot = {
      kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

      kernelPatches = [
        {
          name = "nvidia-dgx-station-aqtion";
          patch = null;
          structuredExtraConfig = with lib.kernel; {
            NET_VENDOR_AQUANTIA = yes;
            AQTION = module;
          };
        }
      ]
      ++ lib.optional cfg.kernel64kPages {
        name = "nvidia-grace-64k-pages";
        patch = null;
        structuredExtraConfig = with lib.kernel; {
          ARM64_64K_PAGES = yes;
          NODES_SHIFT = freeform "6";
          # The default CMA is too small for the atomic DMA pool with 64K pages
          CMA_SIZE_MBYTES = lib.mkForce (freeform "1024");
        };
      };

      kernelParams = lib.mkIf cfg.tuning [
        "init_on_alloc=0"
        "numa_balancing=disable"
        "acpi_power_meter.force_cap_on=y"
      ];

      initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "usb_storage"
        "usbhid"
      ];
    };

    powerManagement.cpuFreqGovernor = lib.mkIf cfg.tuning (lib.mkDefault "performance");

    # atlantic enables LRO by default, which breaks TCP GRO
    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="net", DRIVERS=="atlantic", RUN+="${lib.getExe pkgs.ethtool} -K $name lro off"
    '';

    hardware = {
      enableRedistributableFirmware = lib.mkDefault true;
      graphics.enable = lib.mkDefault true;

      nvidia = {
        package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.latest;
        nvidiaPersistenced = lib.mkDefault true;
      };
    };
  };
}
