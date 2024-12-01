{ config, lib, ... }:
{
  imports = [
    ../common
    ../common/intel.nix
  ];

  config = lib.mkMerge [
    {
      hardware.intelgpu.loadInInitrd = lib.versionOlder config.boot.kernelPackages.kernel.version "6.2";
      # same as 13th gen framework 13-inch
      hardware.framework.laptop13.audioEnhancement.rawDeviceName = lib.mkDefault "alsa_output.pci-0000_00_1f.3.analog-stereo";
    }
    # https://community.frame.work/t/tracking-hard-freezing-on-fedora-36-with-the-new-12th-gen-system/20675/391
    (lib.mkIf (lib.versionOlder config.boot.kernelPackages.kernel.version "6.2") {
      boot.kernelParams = [
        # Workaround iGPU hangs
        # https://discourse.nixos.org/t/intel-12th-gen-igpu-freezes/21768/4
        "i915.enable_psr=1"
      ];
    })
    (lib.mkIf (lib.versionOlder config.boot.kernelPackages.kernel.version "6.8") {
      boot.blacklistedKernelModules = [
        # This enables the brightness and airplane mode keys to work
        # https://community.frame.work/t/12th-gen-not-sending-xf86monbrightnessup-down/20605/11
        "hid-sensor-hub"
        # This fixes controller crashes during sleep
        # https://community.frame.work/t/tracking-fn-key-stops-working-on-popos-after-a-while/21208/32
        (lib.mkIf (config.hardware.framework.enableKmod == false) "cros_ec_lpcs")
      ];

      boot.kernelParams = [
        # For Power consumption
        # https://kvark.github.io/linux/framework/2021/10/17/framework-nixos.html
        # Update 04/2024: Combined with acpi_osi from framework-intel it increases the idle power-usage in my test (SebTM)
        # (see: https://github.com/NixOS/nixos-hardware/pull/903#issuecomment-2068146658)
        "mem_sleep_default=deep"
      ];

      # Further tweak to ensure the brightness and airplane mode keys work
      # https://community.frame.work/t/responded-12th-gen-not-sending-xf86monbrightnessup-down/20605/67
      systemd.services.bind-keys-driver = {
        description = "Bind brightness and airplane mode keys to their driver";
        wantedBy = [ "default.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
        script = ''
          ls -lad /sys/bus/i2c/devices/i2c-*:* /sys/bus/i2c/drivers/i2c_hid_acpi/i2c-*:*
          if [ -e /sys/bus/i2c/devices/i2c-FRMW0001:00 -a ! -e /sys/bus/i2c/drivers/i2c_hid_acpi/i2c-FRMW0001:00 ]; then
            echo fixing
            echo i2c-FRMW0001:00 > /sys/bus/i2c/drivers/i2c_hid_acpi/bind
            ls -lad /sys/bus/i2c/devices/i2c-*:* /sys/bus/i2c/drivers/i2c_hid_acpi/i2c-*:*
            echo done
          else
            echo no fix needed
          fi
        '';
      };
    })
  ];
}
