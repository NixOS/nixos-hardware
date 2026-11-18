{
  config,
  lib,
  ...
}:
{
  imports = [
    ../../../common/cpu/intel/meteor-lake
    ../../../common/pc/laptop
    ../../../common/pc/ssd
    ../../../common/gpu/nvidia/prime.nix
  ];

  hardware.intelgpu.driver = lib.mkIf (lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.8") "xe";

  boot.kernelParams = lib.mkIf (config.hardware.intelgpu.driver == "xe") [
    "i915.force_probe=!7d55"
    "xe.force_probe=7d55"
  ];

  environment.variables = lib.mkIf (config.hardware.intelgpu.driver == "xe") {
    INTEL_XE_IGNORE_EXPERIMENTAL_WARNING = 1;
  };

  hardware = {
    intel-gpu-tools.enable = lib.mkDefault true;
    cpu.intel.npu.enable = lib.mkDefault true;

    graphics.enable = lib.mkDefault true;
    nvidia = {
      nvidiaSettings = lib.mkDefault true;
      modesetting.enable = lib.mkDefault true;
      open = lib.mkDefault true;
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
      powerManagement = {
        enable = lib.mkDefault true;
        finegrained = lib.mkDefault true;
      };
      dynamicBoost.enable = lib.mkDefault true;
    };
  };

  # Some users also reported that the following additional lines are necessary too:
  # https://wiki.archlinux.org/title/PRIME#NVIDIA
  services.udev.extraRules = ''
    # Enable runtime PM for NVIDIA VGA/3D controller devices on adding device
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TEST=="power/control", ATTR{power/control}="auto"
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", TEST=="power/control", ATTR{power/control}="auto"
  '';

  services.thermald.enable = lib.mkDefault true;
}
