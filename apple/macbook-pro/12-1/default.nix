{ lib, pkgs, ... }:

{
  imports = [
    ../.
    ../../../common/pc/laptop/ssd
    <nixpkgs/nixos/modules/hardware/network/broadcom-43xx.nix>
  ];

  powerManagement = {
    # enable gradually increasing/decreasing CPU frequency, rather than using
    # "powersave", which would keep CPU frequency at 0.8GHz.
    cpuFreqGovernor = lib.mkDefault "conservative";

    # brcmfmac being loaded during hibernation would not let a successful resume
    # https://bugzilla.kernel.org/show_bug.cgi?id=101681#c116
    powerUpCommands = lib.mkBefore "${pkgs.kmod}/bin/modprobe brcmfmac";
    powerDownCommands = lib.mkBefore "${pkgs.kmod}/bin/rmmod brcmfmac";
  };

  # USB subsystem wakes up MBP right after suspend unless we disable it.
  services.udev.extraRules = lib.mkDefault ''
    SUBSYSTEM=="pci", KERNEL=="0000:00:14.0", ATTR{power/wakeup}="disabled"
  '';
}
