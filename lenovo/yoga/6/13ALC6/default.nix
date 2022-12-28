{ lib, pkgs, ...  }:

{
  imports = [
    ../../../thinkpad/yoga.nix
    ../../../../common/gpu/amd/default.nix
  ];

  boot.initrd.kernelModules = [ "ideapad_laptop" ];
  hardware.opengl.extraPackages = with pkgs; [
    vaapiVdpau
    libvdpau-va-gl
  ];

  # Latest Kernel
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  # energy savings
  hardware.bluetooth.powerOnBoot = lib.mkDefault false;
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = lib.mkDefault true;
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
