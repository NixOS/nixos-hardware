{
  imports = [
    ../.
    ../../../../common/pc/ssd
    ../../../../common/cpu/intel/meteor-lake
  ];

  boot.kernelParams = [
    "i915.enable_guc=3"
    "i915.force_probe=7d55"
  ];

  hardware.trackpoint.device = "TPPS/2 Synaptics TrackPoint";
}
