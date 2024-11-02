# There is apparently a bug that affects Framework computers that causes black
# screen on resume from sleep or hibernate with kernel version 6.11.  Framework
# have published a workaround; this applies that workaround.
#
# https://fosstodon.org/@frameworkcomputer/113406887743149089
# https://github.com/FrameworkComputer/linux-docs/blob/main/hibernation/kernel-6-11-workarounds/suspend-hibernate-bluetooth-workaround.md#workaround-for-suspendhibernate-black-screen-on-resume-kernel-611
{
  config,
  lib,
  pkgs,
  ...
# TODO: drop this if linux 6.11 goes EOL
}: lib.mkIf ((config.boot.kernelPackages.kernelAtLeast "6.11") && (config.boot.kernelPackages.kernelOlder "6.12")) {
  systemd.services = {
    bluetooth-rfkill-suspend = {
      description = "Soft block Bluetooth on suspend/hibernate";
      before = ["sleep.target"];
      unitConfig.StopWhenUnneeded = true;
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.util-linux}/bin/rfkill block bluetooth";
        ExecStartPost = "${pkgs.coreutils}/bin/sleep 3";
        RemainAfterExit = true;
      };
      wantedBy = ["suspend.target" "hibernate.target" "suspend-then-hibernate.target"];
    };

    bluetooth-rfkill-resume = {
      description = "Unblock Bluetooth on resume";
      after = ["suspend.target" "hibernate.target" "suspend-then-hibernate.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.util-linux}/bin/rfkill unblock bluetooth";
      };
      wantedBy = ["suspend.target" "hibernate.target" "suspend-then-hibernate.target"];
    };
  };
}
