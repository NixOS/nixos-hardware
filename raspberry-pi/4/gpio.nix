{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.hardware.raspberry-pi."4".gpio = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable udev rules and kernelParams that make lgpio and pigpio work";
      default = false;
    };
  };
  config =
    let
      cfg = config.hardware.raspberry-pi."4".gpio;
    in
    lib.mkIf cfg.enable {
      users.groups.gpio = lib.mkDefault { };

      # the bit that matters to lgpio here is
      # "${pkgs.coreutils}/bin/chgrp gpio /dev/%k && chmod 660 /dev/%k"
      # see https://github.com/NixOS/nixpkgs/pull/352308

      # sudo udevadm test --action=add /dev/gpiochip0 to test

      # import lgpio; lgpio.gpiochip_open(0) should show "1" and not raise
      # an exception

      services.udev.extraRules = lib.mkBefore ''
        KERNEL=="gpiomem", GROUP="gpio", MODE="0660"
        SUBSYSTEM=="gpio", KERNEL=="gpiochip*", ACTION=="add", PROGRAM="${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/chgrp gpio /dev/%k && chmod 660 /dev/%k && ${pkgs.coreutils}/bin/chgrp -R gpio /sys/class/gpio && ${pkgs.coreutils}/bin/chmod -R g=u /sys/class/gpio'"
        SUBSYSTEM=="gpio", ACTION=="add", PROGRAM="${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/chgrp -R gpio /sys%p && ${pkgs.coreutils}/bin/chmod -R g=u /sys%p'"
      '';

      boot.kernelParams = [
        "iomem=relaxed" # for pigpiod
      ];
    };
}
