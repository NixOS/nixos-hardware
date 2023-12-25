{
  imports = [
    ../.
    ../../../common/cpu/intel
  ];

  boot = {
    extraModprobeConfig = ''
      options bbswitch use_acpi_to_detect_card_state=1
      options thinkpad_acpi force_load=1 fan_control=1
    '';
    # TODO: probably enable tcsd? Is this line necessary?
    kernelModules = [ "tpm-rng" ];
  };
}
