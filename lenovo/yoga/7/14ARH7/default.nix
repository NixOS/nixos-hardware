{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault mkMerge;

in {
  imports = [
    ../../../../common/cpu/amd
    # Better power-savings from AMD PState:
    ../../../../common/cpu/amd/pstate.nix
    ../../../../common/gpu/amd
    ## "prime.nix" loads this, aleady:
    # ../../../../common/gpu/nvidia
    ../../../../common/gpu/nvidia/prime.nix
    ../../../../common/pc/laptop
    ../../../../common/pc/laptop/acpi_call.nix
    ../../../../common/pc/ssd
  ];

  config = mkMerge [
    {
      # Configure basic system settings:
      boot = {
        kernelModules = [ "kvm-amd" ];
        kernelParams = [
          "mem_sleep_default=deep"
          "pcie_aspm.policy=powersupersave"

          ## Supposed to help fix for suspend issues: SSD not correctly working, and Keyboard not responding:
          ## Not needed for the 6.1+ kernels?
          # "iommu=pt"

          ## Fixes for s2idle:
          ##    https://www.phoronix.com/news/More-s2idle-Rembrandt-Linux
          # "acpi.prefer_microsoft_guid=1"
          ## Appears to have been renamed?
          "acpi.prefer_microsoft_dsm_guid=1"
        ];

        blacklistedKernelModules = [ "nouveau" ];
      };
    }

    {
      ## Graphics settings

      ## AMD RX680
      # services.xserver.videoDrivers = mkDefault [ "amdgpu" ];

      # NVIDIA GeForce RTX 3050 Mobile (Ampere)
      services.xserver.videoDrivers = mkDefault [ "nvidia" ];

      hardware = {
        ## Enable the Nvidia card, as well as Prime and Offload:
        amdgpu.loadInInitrd = true;
        opengl.extraPackages = with pkgs; [
          vaapiVdpau
          libvdpau-va-gl
        ];

        nvidia = {
          modesetting.enable = true;
          nvidiaSettings = true;

          prime = {
            offload = {
              enable = true;
              enableOffloadCmd = true;
            };
            amdgpuBusId = "PCI:4:0:0";
            nvidiaBusId = "PCI:1:0:0";
          };

          powerManagement = {
            enable = true;
            # finegrained = true
          };
        };
      };
    }
  ];
}
