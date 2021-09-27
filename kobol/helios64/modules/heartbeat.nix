{ pkgs, lib, ... }:
{
  systemd.services.heartbeat = {
    enable = true;
    description = "Enable heartbeat & network activity led on Helios64";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${lib.getBin pkgs.bash}/bin/bash -c 'echo heartbeat | ${lib.getBin pkgs.coreutils}/bin/tee /sys/class/leds/helios64\\:\\:status/trigger'
        ${lib.getBin pkgs.bash}/bin/bash -c 'echo netdev | ${lib.getBin pkgs.coreutils}/bin/tee /sys/class/leds/helios64\\:blue\\:net/trigger'
        ${lib.getBin pkgs.bash}/bin/bash -c 'echo eth0 | ${lib.getBin pkgs.coreutils}/bin/tee /sys/class/leds/helios64\\:blue\\:net/device_name'
        ${lib.getBin pkgs.bash}/bin/bash -c 'echo 1 | ${lib.getBin pkgs.coreutils}/bin/tee /sys/class/leds/helios64\\:blue\\:net/link'
        ${lib.getBin pkgs.bash}/bin/bash -c 'echo 1 | ${lib.getBin pkgs.coreutils}/bin/tee /sys/class/leds/helios64\\:blue\\:net/rx'
        ${lib.getBin pkgs.bash}/bin/bash -c 'echo 1 | ${lib.getBin pkgs.coreutils}/bin/tee /sys/class/leds/helios64\\:blue\\:net/tx'
      '';
    };
    after = [ "getty.target" ];
    wantedBy = [ "multi-user.target" ];
  };
}
