{ config, lib, ...}:
with lib;
{
  imports = [
    ./..
    ../../../common/cpu/amd
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/amd
  ];

  # fix suspend problem: https://www.reddit.com/r/gpdwin/comments/16veksm/win_max_2_2023_linux_experience_suspend_problems/
  services.udev.extraRules = ''
    ACTION=="add" SUBSYSTEM=="pci" ATTR{vendor}=="0x1022" ATTR{device}=="0x14ee" ATTR{power/wakeup}="disabled"
  '';
}
