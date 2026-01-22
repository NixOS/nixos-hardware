{
  lib,
  pkgs,
  config,
  ...
}:
let
  # Starting with kernel 6.8, the console font is set in the kernel automatically to a 16x32 font:
  # https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=dfd19a5004eff03755967086aa04254c3d91b8ec
  oldKernel = lib.versionOlder config.boot.kernelPackages.kernel.version "6.8";
in
{
  # Just set the console font, don't mess with the font settings
  console.font = lib.mkIf oldKernel (
    lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz"
  );
  console.earlySetup = lib.mkIf oldKernel (lib.mkDefault true);
}
