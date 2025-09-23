{
  lib,
  ...
}:
{
  imports = [
    ../../../common/cpu/intel/arrow-lake
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  boot = {
    # DSP-based SOF drivers currently don't work due to missing topology
    # definitions, so we fall back to old snd_hda_intel drivers
    # See https://thesofproject.github.io/latest/getting_started/intel_debug/introduction.html#pci-devices-introduced-after-2016
    #
    # Last tested with sof-firmware version 2025.05; newer SOF releases
    # may include updated topologies
    extraModprobeConfig = ''
      options snd-intel-dspcfg dsp_driver=1
    '';

    # HACK: Fix the infamous "Unable to change power state from D3cold to D0"
    # error when resuming the system from a suspended state, by _completely_
    # disabling PCIe port power management and thereby preventing the Wi-Fi
    # adapter from turning off at all.
    #
    # This is theoretically bad from a battery life standpoint, but it's
    # necessary until Intel ships a functioning firmware release that doesn't
    # suffer from this issue. In my real-world testing this doesn't seem to
    # have caused a noticable decrease in battery life, however.
    #
    # See Intel's (non-)response regarding this issue with this exact model at:
    # https://community.intel.com/t5/Wireless/Intel-WiFi-7-BE200-loses-connection-after-suspend-resume-on/m-p/1700055
    #
    # Last tested to be necessary on ucode version 98 — this might no
    # longer be necessary for newer firmware releases!
    kernelParams = [ "pcie_port_pm=off" ];
  };
}
