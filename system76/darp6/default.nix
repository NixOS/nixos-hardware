# Hardware profile for the Darter Pro 6 laptop by System76.
#
# https://system76.com/laptops/darter
#
# Regarding kernel modules, darp6 needs system76-acpi-dkms, not system76-dkms:
#
# [1] https://github.com/pop-os/system76-dkms/issues/39
# jackpot51> system76-acpi-dkms is the correct driver to use on the darp6
#
# system76-io-dkms also appears to be loaded on darp6 with Pop!_OS, and
# system76-dkms does not, and in fact refuses to load.

{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.hardware.system76.darp6;

  # Allow silencing the warning about these options if either is defined.
  soundSettingsDefined =
    options.hardware.system76.darp6.soundVendorId.isDefined
    || options.hardware.system76.darp6.soundSubsystemId.isDefined;

  # We neeed both options non-null to be able to apply the headset fixup though.
  soundSettingsAvailable =
    soundSettingsDefined && (cfg.soundVendorId != null && cfg.soundSubsystemId != null);
in
{
  imports = [
    ../.
    ../../common/pc/laptop
    ../../common/pc/ssd
  ];

  options.hardware.system76.darp6 = {
    soundVendorId = lib.mkOption {
      type = with lib.types; nullOr (strMatching "0x[0-9a-f]{8}");
      description = ''
        The vendor ID of the sound card PCI device, for applying the headset fixup.
        This should be set to the value of the following file on your Darter Pro:
            /sys/class/sound/hwC0D0/vendor_id
        If this option has the default null value, then the headset fixup will
        not be applied.
      '';
    };
    soundSubsystemId = lib.mkOption {
      type = with lib.types; nullOr (strMatching "0x[0-9a-f]{8}");
      description = ''
        The subsystem ID of the sound card PCI device, for applying the headset fixup.
        This should be set to the value of the following file on your Darter Pro:
            /sys/class/sound/hwC0D0/subsystem_id
        If this option has the default null value, then the headset fixup will
        not be applied.
      '';
    };
  };

  config = lib.mkMerge [
    {
      warnings = lib.optional (!soundSettingsDefined) ''
        For full Darter Pro support, set the options:
        - hardware.system76.darp76.soundVendorId
        - hardware.system76.darp76.soundSubsystemId
        You can copy these values directly from:
        - /sys/class/sound/hwC0D0/vendor_id
        - /sys/class/sound/hwC0D0/subsystem_id
        The headset audio fixup will not be applied without these values.
        Set these options to null to silence this warning.
      '';
    }

    # Apply the headset fixup patch from system76-driver, if the necessary
    # options have been provided.
    #
    # See occurrences of "darp" in:
    # https://github.com/pop-os/system76-driver/blob/master/system76driver/actions.py
    # https://github.com/pop-os/system76-driver/blob/master/system76driver/products.py
    (lib.mkIf soundSettingsAvailable {
      boot.extraModprobeConfig = ''
        options snd-hda-intel model=headset-mode-no-hp-mic patch=system76-audio-patch
      '';

      hardware.firmware = [
        (pkgs.writeTextFile {
          name = "system76-audio-patch";
          destination = "/lib/firmware/system76-audio-patch";
          text = ''
            [codec]
            ${cfg.soundVendorId} ${cfg.soundSubsystemId} 0

            [pincfg]
            0x1a 0x01a1913c
          '';
        })
      ];
    })
  ];
}
