{ config, lib, ... }:

let
  inherit (lib) mkDefault;
in
{
  imports = [
    ../../../../common/cpu/amd
    ../../../../common/gpu/amd
    ../../../../common/gpu/nvidia/prime.nix
    ../../../../common/pc/laptop
    ../../../../common/pc/ssd
    ../../../../common/wifi/mediatek/mt7925
    ../../../../common/wifi/mediatek/mt7925/iwd.nix
  ];

  # Razer Blade 14 (RZ09-0530 / 2025) - AMD Ryzen AI 9 HX 370 + NVIDIA RTX 5060 Max-Q

  # Enable AMD iGPU and NVIDIA dGPU drivers
  services.xserver.videoDrivers = mkDefault [
    "amdgpu"
    "nvidia"
  ];

  hardware = {
    # Firmware for AMD CPU/GPU, WiFi, Bluetooth
    enableRedistributableFirmware = mkDefault true;

    # Enable AMD iGPU in initrd for early KMS
    amdgpu.initrd.enable = mkDefault true;

    nvidia = {
      modesetting.enable = mkDefault true;
      nvidiaSettings = mkDefault true;

      # Open kernel modules work on Blackwell (RTX 50 series)
      open = mkDefault true;

      prime = {
        offload = {
          enable = mkDefault true;
          enableOffloadCmd = mkDefault true;
        };

        # Bus IDs for Razer Blade 14 2025
        # Obtained via: nix shell nixpkgs#pciutils -c lspci -d ::03xx
        # c4:00.0 (196:0:0) - NVIDIA GeForce RTX 5060 Max-Q
        # c5:00.0 (197:0:0) - AMD Radeon 880M / 890M
        amdgpuBusId = "PCI:197:0:0";
        nvidiaBusId = "PCI:196:0:0";
      };

      # Power management for hybrid graphics
      powerManagement = {
        enable = mkDefault true;
        finegrained = mkDefault true;
      };
    };
  };
}
