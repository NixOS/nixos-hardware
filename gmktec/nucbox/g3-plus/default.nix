/*
  `gmktec-nucbox-g3-plus`:

  Product page:
  <https://www.gmktec.com/products/nucbox-g3-plus-enhanced-performance-mini-pc-with-intel-n150-processor>

  This profile just configures the Intel
  Twin Lake N150 CPU and integrated
  graphics for this mini-PC. fstrim is also
  enabled for the SSD. That's all this seemed
  to need to function properly. As is now
  expected from Intel NUC systems, it provides
  a solid "out-of-the-box" experience. No
  special quirks are apparent.

  We import the Alder Lake modules since Twin
  Lake is just a refreshed version of the
  Alder Lake-N series. Re-using those seems
  to be fine for this purpose.
*/
{
  imports = [
    ../../../common/cpu/intel/alder-lake
    ../../../common/gpu/intel/alder-lake
    ../../../common/pc/ssd
  ];
}
