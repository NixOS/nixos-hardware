{
  config,
  lib,
  ...
}:
{
  boot = {
    # Make sure that EC drivers are loaded
    kernelModules = [
      "cros_ec"
      "cros_ec_lpcs"
    ];

    # Make sure that the charge control driver is loaded
    extraModProbeConfig = ''
      options cros_charge_control probe-with_fwk_charge_control=1
    '';
  };
}
