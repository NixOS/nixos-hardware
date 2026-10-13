{
  imports = [
    ../../../../common/cpu/intel/comet-lake
    ../../../../common/gpu/intel/comet-lake
  ];

  # this does not enable sound by itself, but if you enable pipewire then this is required for non-bluetooth sinks
  # 1 is the old Intel HD Audio driver
  # 3 is the newer SOF driver that is incompatible with coreboot
  boot.kernelParams = [
    "snd_intel_dspcfg.dsp_driver=1"
  ];
}
