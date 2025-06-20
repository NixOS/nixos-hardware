{ pkgs, ... }:
{
  imports = [
    ../../../../common/cpu/amd
    ../../../../common/gpu/amd
    ../../../../common/pc/ssd
  ];

  services.udev.extraRules = builtins.concatStringsSep "\n" (
    [ "# Properly suspend the system." ]
    ++ (map
      (
        device:
        ''SUBSYSTEM=="pci", ACTION=="add", ATTR{vendor}=="0x144d", ATTR{device}=="${device}", RUN+="${pkgs.runtimeShell} -c 'echo 0 > /sys/bus/pci/devices/$kernel/d3cold_allowed'"''
      )
      [
        "0xa80a"
        "0xa808"
      ]
    )
  );
}
