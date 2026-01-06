# MediaTek MT7925 WiFi 7 / Bluetooth support
#
# The MT7925 is a WiFi 7 (802.11be) + Bluetooth combo chip found in many
# 2024-2025 laptops. It requires specific workarounds for stable operation.
#
# Known issues:
# - Power management causes random disconnections
# - ASPM (Active State Power Management) causes hangs
# - CLC (Country Location Code) causes 6GHz band instability
# - WiFi often fails to reconnect after suspend/resume
# - wpa_supplicant has issues; iwd is recommended
#
# Devices using MT7925:
# - Razer Blade 14 (RZ09-0530) 2025
# - ThinkPad P16s Gen 4
# - Other 2024-2025 laptops with WiFi 7
#
# References:
# - https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2118755
# - https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2133863
{
  lib,
  pkgs,
  ...
}:

{
  # ===========================================================================
  # Kernel Recommendation
  # ===========================================================================
  # Kernel 6.18+ is recommended for stable MT7925 operation.
  # Earlier kernels may have driver bugs causing disconnections or hangs.
  # Set: boot.kernelPackages = pkgs.linuxPackages_latest;

  # ===========================================================================
  # Kernel Module Parameters
  # ===========================================================================
  # Disable power management at driver level during module load
  boot.extraModprobeConfig = ''
    # MT7925 WiFi - disable all power management for stability
    options mt7925e disable_aspm=1
    options mt7925e power_save=0

    # Disable CLC (Country Location Code) - fixes 6GHz band stability
    options mt7925-common disable_clc=1
  '';

  # ===========================================================================
  # NetworkManager Configuration
  # ===========================================================================
  networking.networkmanager.wifi = {
    # Disable WiFi power saving (causes disconnections)
    powersave = lib.mkDefault false;

    # Consistent MAC during scans (randomization causes issues)
    scanRandMacAddress = lib.mkDefault false;
  };

  # ===========================================================================
  # Suspend/Resume Fix
  # ===========================================================================
  # Restart NetworkManager after suspend to clear stale driver state
  systemd.services.mediatek-wifi-resume = {
    description = "Restart NetworkManager after suspend to fix MediaTek WiFi";
    wantedBy = [
      "suspend.target"
      "hibernate.target"
      "hybrid-sleep.target"
    ];
    after = [
      "suspend.target"
      "hibernate.target"
      "hybrid-sleep.target"
    ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl restart NetworkManager.service";
    };
  };
}
