{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  boot = {
    initrd = {
      # From OEM Ubuntu Image
      availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "rtsx_pci_sdmmc"];
      kernelModules = lib.mkDefault [];
    };
    kernelParams = lib.mkDefault ["mem_sleep_default=deep" "nowatchdog" "i915.enable_guc=3"];
    kernelModules = ["kvm-intel"];
    # r8169 is from OEM Ubuntu Image
    blacklistedKernelModules = ["r8169" "iTCO_wdt" "intel_oc_wdt"];
    extraModulePackages = lib.mkDefault [];
    # Need 6.1 at the minimum to ensure reliable Wi-Fi
    kernelPackages = lib.mkDefault (
      if lib.versionOlder pkgs.linuxPackages.kernel.version "6.1"
      then pkgs.linuxPackages_6_1
      else pkgs.linuxPackages
    );
  };

  # Necessary for accurate dual-battery power-level reading after wake
  systemd.services.upower-resume = {
    description = "Restart UPower after resume to refresh battery stats";
    wantedBy = ["suspend.target" "hibernate.target" "hybrid-sleep.target"];
    after = ["systemd-suspend.service" "systemd-hibernate.service" "systemd-hybrid-sleep.service"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl restart upower";
    };
  };

  # TLP Settings from OEM Ubuntu Image
  services.tlp.settings = lib.mkDefault {
    TLP_DEFAULT_MODE = "BAT";
    TLP_PERSISTENT_DEFAULT = 1;
    USB_BLACKLIST = "0bda:8153";
    RUNTIME_PM_DRIVER_BLACKLIST = "igb igc";
    START_CHARGE_THRESH_BAT1 = 50;
    STOP_CHARGE_THRESH_BAT1 = 80;

    # Energy Star compliance
    DISK_IDLE_SECS_ON_BAT = 2;
    MAX_LOST_WORK_SECS_ON_BAT = 60;
  };

  # Fingerprint Reader
  services.fprintd = {
    enable = lib.mkDefault true;
    package = lib.mkDefault pkgs.fprintd-tod;
    tod.enable = lib.mkDefault true;
    tod.driver = lib.mkDefault pkgs.libfprint-2-tod1-broadcom;
  };

  # Necessary for Wi-Fi/Bluetooth firmware
  hardware.enableRedistributableFirmware = true;
}
