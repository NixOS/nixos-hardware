{ ... }:
{
  imports = [
    ../.
    ../../../common/pc/ssd
  ];

  # Somehow psmouse does not load automatically on boot for me
  boot.initrd.kernelModules = [ "psmouse" ];
}
