# pulled out all the x1 specific things
# for nixos-hardware

{ config, pkgs, ... }:

{

  boot.kernelModules = [ "acpi" "thinkpad-acpi" "acpi-call" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.acpi_call ];
  boot.extraModprobeConfig = "options thinkpad_acpi experimental=1 fan_control=1";

  environment.systemPackages = with pkgs; [
    tlp
  ];

  # enable thermal trottle
  services.thermald.enable = true;

  # enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # handle lid close hibernate, suspend, or ignore
  systemd.extraConfig = "";
  services.logind.extraConfig = ''
    HandleLidSwitch=hibernate
    LidSwitchIgnoreInhibited=yes
  '';

  # Thinkpad power services with some sample values
  services.tlp.enable = true;
  services.tlp.extraConfig = ''
      DEVICES_TO_DISABLE_ON_STARTUP="bluetooth"
      START_CHARGE_THRESH_BAT0=75
      STOP_CHARGE_THRESH_BAT0=90
      START_CHARGE_THRESH_BAT1=75
      STOP_CHARGE_THRESH_BAT1=90
      CPU_SCALING_GOVERNOR_ON_BAT=powersave
      ENERGY_PERF_POLICY_ON_BAT=powersave
    '';
}
