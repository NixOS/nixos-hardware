{ lib, pkgs, modulesPath, ... }:

{
  imports = [
    ../.
    ../../../common/pc/laptop/ssd
    "${modulesPath}/hardware/network/broadcom-43xx.nix"
  ];

  powerManagement = {
    # Enable gradually increasing/decreasing CPU frequency, rather than using
    # "powersave", which would keep CPU frequency at 0.8GHz.
    cpuFreqGovernor = lib.mkDefault "conservative";

    # brcmfmac being loaded during hibernation would not let a successful resume
    # https://bugzilla.kernel.org/show_bug.cgi?id=101681#c116.
    # Also brcmfmac could randomly crash on resume from sleep.
    powerUpCommands = lib.mkBefore "${pkgs.kmod}/bin/modprobe brcmfmac";
    powerDownCommands = lib.mkBefore ''
      ${pkgs.kmod}/bin/rmmod -f -v brcmfmac_wcc 2>/dev/null || true
      ${pkgs.kmod}/bin/rmmod brcmfmac
      '';
  };

  # USB subsystem wakes up MBP right after suspend unless we disable it.
  services.udev.extraRules = lib.mkDefault ''
    SUBSYSTEM=="pci", KERNEL=="0000:00:14.0", ATTR{power/wakeup}="disabled"
  '';
}
