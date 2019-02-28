{ config, lib, pkgs, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop/acpi_call.nix
    ../.
  ];

  systemd.paths.trackpoint = {
    pathConfig = {
      PathExists = "/sys/devices/rmi4-00/rmi4-00.fn03/serio2";
      Unit = "trackpoint.service";
    };
  };

  systemd.services.trackpoint.script = ''
    ${config.systemd.package}/bin/udevadm trigger --attr-match=name="${config.hardware.trackpoint.device}"
  '';
}
