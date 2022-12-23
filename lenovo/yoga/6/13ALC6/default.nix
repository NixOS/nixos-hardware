{ lib, pkgs, ...  }:

{
  boot.initrd.kernelModules = [ 
    "amdgpu"
    "ideapad_laptop"
  ];
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
    amdvlk
    vaapiVdpau
    libvdpau-va-gl
  ];
  hardware.opengl.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];
  hardware.opengl = {
    driSupport = lib.mkDefault true;
    driSupport32Bit = lib.mkDefault true;
  };
  environment.variables.AMD_VULKAN_ICD = lib.mkDefault "RADV";

  # Latest Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.bluetooth.powerOnBoot = lib.mkDefault false;
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = lib.mkDefault true;
  # automatic screen orientation, only works in X11
  hardware.sensor.iio.enable = true;
  # energy savings
  boot.kernelParams = ["mem_sleep_default=deep" "pcie_aspm.policy=powersupersave"];
  powerManagement.enable = lib.mkDefault true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
  services.tlp.settings = {
    # CPU
    CPU_SCALING_GOVERNOR_ON_BAT="ondemand";
    CPU_SCALING_GOVERNOR_ON_AC="performance";
    CPU_BOOST_ON_AC=1;
    CPU_BOOST_ON_BAT=0;
    # Stop charging battery at 60%, ideapad_laptop driver required
    #STOP_CHARGE_THRESH_BAT0=1;
    # Stop charging battery at 100%
    STOP_CHARGE_THRESH_BAT0=0;
    # GPU
    RADEON_DPM_PERF_LEVEL_ON_AC="auto";
    RADEON_DPM_PERF_LEVEL_ON_BAT="low";
  };
}
