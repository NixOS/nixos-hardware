{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../../../../../common/gpu/nvidia/prime.nix
    ../../../../../common/gpu/nvidia/turing
    ../../../../../common/cpu/intel/tiger-lake
    ../.
  ];

  # For suspending to RAM to work, set Config -> Power -> Sleep State to "Linux S3" in EFI.

  hardware = {
    enableAllFirmware = lib.mkDefault true;

    graphics = {
      enable = lib.mkDefault true;
      enable32Bit = lib.mkDefault true;
    };

    intelgpu.driver = "xe";

    nvidia = {
      modesetting.enable = lib.mkDefault true;

      powerManagement = {
        enable = lib.mkDefault false;
        finegrained = lib.mkDefault false;
      };

      package = config.boot.kernelPackages.nvidiaPackages.stable;

      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  # Critical kernel parameters for ThinkPad P14s Intel Gen 2
  boot = {
    kernelParams = [
      # Intel IOMMU conflict resolution
      "intel_iommu=off"

      # Force S3 deep sleep instead of problematic S0ix
      "mem_sleep_default=deep"

      # NVIDIA hybrid graphics suspend support
      "nvidia-drm.modeset=1" # This is hardware.nvidia.modesetting.enable = true;
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"

      # Disable asynchronous power management
      "pm_async=0"

      # PCIe power management fixes
      "pcie_aspm=off"

      # ACPI compatibility improvements
      "acpi_osi=linux"
    ];

    # Module configuration for hybrid graphics
    extraModprobeConfig = ''
      # NVIDIA video memory preservation
      options nvidia NVreg_PreserveVideoMemoryAllocations=1
      options nvidia NVreg_TemporaryFilePath=/var/tmp

      # Blacklist conflicting framebuffer drivers
      blacklist nvidiafb
    '';
  };

  systemd = {
    services = {
      nvidia-suspend.enable = lib.mkDefault true;
      nvidia-resume.enable = lib.mkDefault true;
      nvidia-hibernate.enable = lib.mkDefault true;
      suspend-debug = {
        description = "Enable suspend debugging";
        wantedBy = [ "multi-user.target" ];
        script = ''
          echo 1 > /sys/power/pm_debug_messages || true
        '';
        serviceConfig.Type = "oneshot";
        serviceConfig.RemainAfterExit = true;
      };
    };
    tmpfiles.rules = [
      "d /var/tmp 1777 root root 10d"
    ];
    # Systemd sleep configuration
    sleep.extraConfig = ''
      HibernateDelaySec=30m
      SuspendState=mem
    '';
  };

  services = {
    power-profiles-daemon.enable = lib.mkDefault true;
    xserver.videoDrivers = [ "nvidia" ];

    # Lid behavior configuration
    logind = {
      lidSwitch = "suspend-then-hibernate";
      lidSwitchExternalPower = "lock";
      powerKey = "suspend";
    };
  };

  powerManagement.enable = lib.mkDefault true;
}
