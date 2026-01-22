{
  # Work around an issue causing the system to unsuspend immediately after suspend
  # and/or hang after suspend.
  #
  # See https://www.reddit.com/r/gigabyte/comments/p5ewjn/comment/ksbm0mb/ /u/Demotay
  #
  # Most suggestions elsewhere are to disable GPP0 and/or GPP8 using /proc/acpi/wakeup, but that is
  # inconvenient because it toggles. This does essentially the same thing using udev, which can set
  # the wakeup attribute to a specific value.
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x1022", ATTR{device}=="0x1483", ATTR{power/wakeup}="disabled"
  '';
}
