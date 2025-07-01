{
  imports = [
    ../.
  ];

  boot.kernelModules = [
    "jc42"
    "tpm_rng"
  ];

  # services.cron.systemCronJobs = [
  #   # Reset 5-minute watchdog timer every minute
  #   "* * * * * ${pkgs.ipmitool}/bin/ipmitool raw 0x30 0x97 1 5"
  # ];
}
