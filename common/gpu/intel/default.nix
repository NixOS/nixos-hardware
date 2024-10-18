{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ../24.05-compat.nix ];
  options.hardware.intelgpu.driver = lib.mkOption {
    description = "Intel GPU driver to use";
    type = lib.types.enum [
      "i915"
      "xe"
    ];
    default = "i915";
  };
  options.hardware.intelgpu.vaapiDriver = lib.mkOption {
    description = "Intel VAAPI driver to use (use null to use both)";
    type = lib.types.nullOr (
      lib.types.enum [
        "intel-vaapi-driver"
        "intel-media-driver"
      ]
    );
    default = null; # Use both drivers when we don't know which one to use
  };
  options.hardware.intelgpu.enableHybridCodec = lib.mkEnableOption "hybrid codec support for Intel GPUs";

  options.hardware.intelgpu.loadInInitrd =
    lib.mkEnableOption "Load the Intel GPU kernel module at stage 1 boot. (Added to `boot.initrd.kernelModules`)"
    // {
      default = true;
    };

  config = {
    boot.initrd.kernelModules = lib.optionals config.hardware.intelgpu.loadInInitrd [
      config.hardware.intelgpu.driver
    ];

    nixpkgs.overlays = lib.optionals config.hardware.intelgpu.enableHybridCodec [
      (
        self: super:
        (
          if pkgs ? intel-vaapi-driver then
            { intel-vaapi-driver = super.intel-vaapi-driver.override { enableHybridCodec = true; }; }
          else if pkgs ? vaapiIntel then
            { vaapiIntel = super.vaapiIntel.override { enableHybridCodec = true; }; }
          else
            builtins.throw "Unable to find Intel VAAPI driver"
        )
      )
    ];

    hardware.graphics.extraPackages =
      lib.optionals
        (
          config.hardware.intelgpu.vaapiDriver == "intel-vaapi-driver"
          || config.hardware.intelgpu.vaapiDriver == null
        )
        (
          with pkgs;
          [
            (
              if pkgs ? intel-vaapi-driver then
                intel-vaapi-driver
              else if pkgs ? vaapiIntel then
                vaapiIntel
              else
                builtins.throw "Unable to find Intel VAAPI driver"
            )
          ]
        )
      ++ lib.optionals
        (
          config.hardware.intelgpu.vaapiDriver == "intel-media-driver"
          || config.hardware.intelgpu.vaapiDriver == null
        )
        (
          with pkgs;
          [
            intel-media-driver
            (
              if pkgs ? vpl-gpu-rt then
                vpl-gpu-rt
              else if pkgs ? onevpl-intel-gpu then
                onevpl-intel-gpu
              else
                builtins.throw "Unable to find OneAPI VAAPI driver"
            )
          ]
        );

    hardware.graphics.extraPackages32 =
      lib.optionals
        (
          config.hardware.intelgpu.vaapiDriver == "intel-vaapi-driver"
          || config.hardware.intelgpu.vaapiDriver == null
        )
        (
          with pkgs.driversi686Linux;
          [
            (
              if pkgs ? intel-vaapi-driver then
                intel-vaapi-driver
              else if pkgs ? vaapiIntel then
                vaapiIntel
              else
                builtins.throw "Unable to find Intel VAAPI driver"
            )
          ]
        )
      ++ lib.optionals
        (
          config.hardware.intelgpu.vaapiDriver == "intel-media-driver"
          || config.hardware.intelgpu.vaapiDriver == null
        )
        (
          with pkgs.driversi686Linux;
          ([ intel-media-driver ] ++ (lib.optionals (pkgs.driversi686Linux ? vpl-gpu-rt) [ vpl-gpu-rt ]))
        );

    assertions = [
      {
        assertion = (
          config.hardware.intelgpu.driver != "xe"
          || lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.8"
        );
        message = "Intel Xe GPU driver is not supported on kernels earlier than 6.8. Update or use the i915 driver.";
      }
    ];
  };
}
