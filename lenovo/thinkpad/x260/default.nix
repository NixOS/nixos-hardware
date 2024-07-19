{
  imports = [
    ../.
    ../../../common/cpu/intel
    ../../../common/pc/laptop/acpi_call.nix
  ];

  boot.kernelParams = [
    # https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_X260#Thinkpad_X260
    "i915.enable_psr=0"
  ];
}
