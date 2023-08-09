{ config, lib, ... }:

let
  cfg = config.hardware.raspberry-pi."4".fkms-3d;
in
{
  options.hardware = {
    raspberry-pi."4".fkms-3d = {
      enable = lib.mkEnableOption ''
        Enable modesetting through fkms-3d
      '';
      cma = lib.mkOption {
        type = lib.types.int;
        default = 512;
        description = ''
          Amount of CMA (contiguous memory allocator) to reserve, in MiB.

          The foundation overlay defaults to 256MiB, for backward compatibility.
          As the Raspberry Pi 4 family of hardware has ample amount of memory, we
          can reserve more without issue.

          Additionally, reserving too much is not an issue. The kernel will use
          CMA last if the memory is needed.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # fixes a crash: https://github.com/raspberrypi/linux/issues/5568
    # can be removed for >= nixos 23.11: https://github.com/NixOS/nixpkgs/pull/247826
    boot.kernelParams = [ "kunit.enable=0" ];

    # doesn't work for the CM module, so we exclude e.g. bcm2711-rpi-cm4.dts
    hardware.deviceTree.filter = "bcm2711-rpi-4*.dtb";

    # Configure for modesetting in the device tree
    hardware.deviceTree = {
      overlays = [
        # Equivalent to:
        # https://github.com/raspberrypi/linux/blob/rpi-6.1.y/arch/arm/boot/dts/overlays/cma-overlay.dts
        {
          name = "rpi4-cma-overlay";
          dtsText = ''
            // SPDX-License-Identifier: GPL-2.0
            /dts-v1/;
            /plugin/;

            / {
              compatible = "brcm,bcm2711";

              fragment@0 {
                target = <&cma>;
                __overlay__ {
                  size = <(${toString cfg.cma} * 1024 * 1024)>;
                };
              };
            };
          '';
        }
        # Equivalent to:
        # https://github.com/raspberrypi/linux/blob/rpi-6.1.y/arch/arm/boot/dts/overlays/vc4-fkms-v3d-overlay.dts
        {
          name = "rpi4-vc4-fkms-v3d-overlay";
          dtsText = ''
            // SPDX-License-Identifier: GPL-2.0
            /dts-v1/;
            /plugin/;

            / {
              compatible = "brcm,bcm2711";

              fragment@1 {
                target = <&fb>;
                __overlay__ {
                  status = "disabled";
                };
              };

              fragment@2 {
                target = <&firmwarekms>;
                __overlay__ {
                  status = "okay";
                };
              };

              fragment@3 {
                target = <&v3d>;
                __overlay__ {
                  status = "okay";
                };
              };

              fragment@4 {
                target = <&vc4>;
                __overlay__ {
                  status = "okay";
                };
              };
            };
          '';
        }
      ];
    };

    # Also configure the system for modesetting.

    services.xserver.videoDrivers = lib.mkBefore [
      "modesetting" # Prefer the modesetting driver in X11
      "fbdev" # Fallback to fbdev
    ];
  };
}
