{ lib, config, ... }: {
  # Enables the amd cpu scaling https://www.kernel.org/doc/html/latest/admin-guide/pm/amd-pstate.html
  # On recent AMD CPUs this can be more energy efficient.

  imports = [ ./. ];
  boot = lib.mkIf (lib.versionAtLeast config.boot.kernelPackages.kernel.version "5.17") {
    kernelParams = [ "initcall_blacklist=acpi_cpufreq_init" ];
    kernelModules = [ "amd-pstate" ];
  };
}
