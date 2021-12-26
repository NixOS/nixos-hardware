{ config, lib, ... }: {
  # Reference to hardware: https://certification.ubuntu.com/hardware/202004-27844
  imports = [
    ../.
    ../../../common/cpu/intel
    ../../../common/pc/laptop/acpi_call.nix
    ../../../common/pc/laptop/ssd
  ];

  # Somehow psmouse does not load automatically on boot for me
  boot.initrd.kernelModules = [ "psmouse" ];
}
