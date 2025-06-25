{ pkgs, ... }:

{
  hardware.fancontrol.enable = true;
  hardware.fancontrol.config = ''
    # Helios4 PWM Fan Control Configuration
    # Temp source : /dev/thermal-cpu
    INTERVAL=10
    FCTEMPS=/dev/fan-j10/pwm1=/dev/thermal-cpu/temp1_input /dev/fan-j17/pwm1=/dev/thermal-cpu/temp1_input
    MINTEMP=/dev/fan-j10/pwm1=40 /dev/fan-j17/pwm1=40
    MAXTEMP=/dev/fan-j10/pwm1=80 /dev/fan-j17/pwm1=80
    MINSTART=/dev/fan-j10/pwm1=20 /dev/fan-j17/pwm1=20
    MINSTOP=/dev/fan-j10/pwm1=29 /dev/fan-j17/pwm1=29
    MINPWM=0
  '';

  boot.kernelModules = [ "lm75" ];

  services.udev.packages = [
    # Fan control
    (pkgs.callPackage (
      {
        stdenv,
        lib,
        coreutils,
      }:
      stdenv.mkDerivation {
        name = "helios4-udev-fancontrol";

        dontUnpack = true;
        dontBuild = true;

        installPhase = ''
          mkdir -p "$out/etc/udev/rules.d/";
          install -Dm644 "${./90-helios4-hwmon.rules}" \
            "$out/etc/udev/rules.d/90-helios4-hwmon.rules"
          substituteInPlace "$out/etc/udev/rules.d/90-helios4-hwmon.rules" \
            --replace '/bin/ln'  '${lib.getBin coreutils}/bin/ln'
        '';

        meta = with lib; {
          description = "Udev rules for fancontrol for the Helios4";
          platforms = platforms.linux;
        };
      }
    ) { })
  ];
}
