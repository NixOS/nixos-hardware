{ config, lib, pkgs, ... }:

{
  imports = [
    ../.
  ];

  boot = {
    kernelParams = [
      # fixes brightness keys, see https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_T430s
      "acpi_osi\='!Windows 2012'"
    ];
  };
}
