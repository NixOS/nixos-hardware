{
  lib,
  ...
}:
{
  imports = [
    ../.
  ];

  # AMD Radeon HD 6770M/6970M (Whistler/Turks, Northern Islands generation)
  # DPM (Dynamic Power Management) did cause boot hangs
  boot.kernelParams = [ "radeon.dpm=0" ];

}
