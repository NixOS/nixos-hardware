/*
  `bee-link-eq14`:

  Product page:
  <https://www.bee-link.com/collections/mini-pc/products/beelink-eq14>

  This profile configures the Intel
  Twin Lake N150 CPU and integrated
  graphics for this mini-PC. fstrim is also
  enabled for the SSD. As is expected from
  Intel NUC-like systems, it provides
  a solid "out-of-the-box" experience. No
  special quirks are apparent.

  We import the Alder Lake modules since Twin
  Lake is just a refreshed version of the
  Alder Lake-N series. Re-using those seems
  to be fine for this purpose.
*/
{
  imports = [
    ../../common/cpu/intel/alder-lake
    ../../common/gpu/intel/alder-lake
    ../../common/pc/ssd
  ];
}
