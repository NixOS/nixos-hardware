{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ../24.05-compat.nix ];

  options.hardware.intelgpu = {
    driver = lib.mkOption {
      description = "Intel GPU driver to use";
      type = lib.types.enum [
        "i915"
        "xe"
      ];
      default = "i915";
    };

    loadInInitrd =
      lib.mkEnableOption "Load the Intel GPU kernel module at stage 1 boot. (Added to `boot.initrd.kernelModules`)"
      // {
        default = true;
      };

    vaapiDriver = lib.mkOption {
      description = "Intel VAAPI driver to use (use null to use both)";
      type = lib.types.nullOr (
        lib.types.enum [
          "intel-vaapi-driver"
          "intel-media-driver"
        ]
      );
      default = null; # Use both drivers when we don't know which one to use
    };

    enableHybridCodec = lib.mkEnableOption "hybrid codec support for Intel GPUs";
  };

  config =
    let
      cfg = config.hardware.intelgpu;

      useIntelVaapiDriver = cfg.vaapiDriver == "intel-vaapi-driver" || cfg.vaapiDriver == null;
      intel-vaapi-driver = (pkgs.intel-vaapi-driver or pkgs.vaapiIntel).override {
        enableHybridCodec = cfg.enableHybridCodec;
      };
      intel-vaapi-driver-32 = (pkgs.driversi686Linux.intel-vaapi-driver or pkgs.driversi686Linux.vaapiIntel).override {
        enableHybridCodec = cfg.enableHybridCodec;
      };

      useIntelOcl = useIntelVaapiDriver && (config.hardware.enableAllFirmware or config.nixpkgs.config.allowUnfree or false);
      intel-ocl = pkgs.intel-ocl;

      useIntelMediaDriver = cfg.vaapiDriver == "intel-media-driver" || cfg.vaapiDriver == null;
      intel-media-driver = pkgs.intel-media-driver;
      intel-media-driver-32 = pkgs.driversi686Linux.intel-media-driver;
      intel-compute-runtime = pkgs.intel-compute-runtime;
      vpl-gpu-rt = pkgs.vpl-gpu-rt or pkgs.onevpl-intel-gpu;
    in
    {
      boot.initrd.kernelModules = lib.optionals cfg.loadInInitrd [ cfg.driver ];

      hardware.graphics.extraPackages =
        lib.optionals useIntelVaapiDriver [ intel-vaapi-driver ]
        ++ lib.optionals useIntelOcl [ intel-ocl ]
        ++ lib.optionals useIntelMediaDriver [
          intel-media-driver
          intel-compute-runtime
          vpl-gpu-rt
        ];

      hardware.graphics.extraPackages32 =
        lib.optionals useIntelVaapiDriver [ intel-vaapi-driver-32 ]
        ++ lib.optionals useIntelMediaDriver [ intel-media-driver-32 ];

      assertions = [
        {
          assertion = (
            cfg.driver != "xe" || lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.8"
          );
          message = "Intel Xe GPU driver is not supported on kernels earlier than 6.8. Update or use the i915 driver.";
        }
      ];
    };
}
