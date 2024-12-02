{ ... }: {
  imports = [
    ../.
    ../../../common/pc/laptop/ssd
  ];

  # Somehow psmouse does not load automatically on boot for me
  boot.initrd.kernelModules = [ "psmouse" ];
}
