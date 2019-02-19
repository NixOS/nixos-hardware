{ config, lib, pkgs, ... }: let
  inherit (lib) types;
in {
  options.hardware.cpu.intel.enable = lib.mkEnableOption "Intel specific settings" // {
    default = true;
  };
  options.hardware.cpu.intel.max-frequency = lib.mkOption {
    type = with types; nullOr int;
    default = 100;
    example = 75;
    description = ''
      Limits the maximum P-State that will be requested by system driver.
      This allows varying CPU performance (reduce CPU heating and battery usage).
      Supported for SandyBridge+ Intel processors.

      The value is percentage. 100 gives best performance (default), 0 gives
      worst performance (though it doesn't stop the CPU, it just sets minimal
      possible frequency). `null` disables this setting.

      Exact frequency values can be checked with `cpupower frequency-info`.

      https://www.kernel.org/doc/Documentation/cpu-freq/intel-pstate.txt
    '';
  };

  config = lib.mkIf config.hardware.cpu.intel.enable {
    boot.initrd.kernelModules = [ "i915" ];

    hardware.cpu.intel.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;

    hardware.opengl.extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];

    system.activationScripts.cpu-frequency-set = let
      max-freq = config.hardware.cpu.intel.max-frequency;
    in lib.mkIf (max-freq != null) {
      text = ''
        max_perf_pct=/sys/devices/system/cpu/intel_pstate/max_perf_pct
        value=${toString max-freq}
        if [[ -f $max_perf_pct ]]; then
          echo $value > $max_perf_pct
        fi
      '';
      deps = [];
    };
  };
}
