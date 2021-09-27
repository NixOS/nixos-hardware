{ pkgs, ... }:
{
  systemd.services.helios64-ups = {
    enable = true;
    description = "Helios64 UPS Action";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/poweroff";
    };
  };

  systemd.timers.helios64-ups = {
    enable = true;
    description = "Helios64 UPS Shutdown timer on power loss";
    # disabling the timer by default. Even though armbian enaled
    # the timer by default through this, we don't, as we can't
    # rely on the udev rules to disable it after a system switch.
    # wantedBy = [ "multi-user.target" ];
    timerConfig = {
      OnActiveSec = "10m";
      AccuracySec = "1s";
      Unit = "helios64-ups.service";
    };
  };
  # The udev rule that will trigger the above service.
  services.udev.packages = [
    (pkgs.callPackage (
      { stdenv, lib, coreutils, systemd }:
      stdenv.mkDerivation {
          name = "helios64-udev-ups";

          dontUnpack = true;
          dontBuild = true;

          installPhase = ''
              mkdir -p "$out/etc/udev/rules.d/";
              install -Dm644 "${./bsp/90-helios64-ups.rules}" \
                "$out/etc/udev/rules.d/90-helios64-ups.rules"
              substituteInPlace "$out/etc/udev/rules.d/90-helios64-ups.rules" \
                  --replace '/bin/ln'  '${lib.getBin coreutils}/bin/ln' \
                  --replace '/usr/bin/systemctl' '${lib.getBin systemd}/bin/systemctl'
          '';

          meta = with lib; {
              description = "Udev rules for UPS for the Helios64";
              platforms = platforms.linux;
          };
      }
    ) {})
  ];
}
