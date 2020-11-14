# Based on instructions from kvalo at: http://lists.infradead.org/pipermail/ath11k/2020-November/000537.html
# The xps/13-9360/qca6174-firmware.nix was a useful reference for how to setup this module.
{ stdenv }:

stdenv.mkDerivation rec {
  name = "${target}-firmware-${version}";
  version = "${branch}-00042";
  branch = "master";
  target = "QCA6390";
  src = builtins.fetchGit {
    url = "https://github.com/kvalo/ath11k-firmware.git";
    ref = "master";
    rev = "45a6c45a19799d3b06fc2287d5ba44e19ee0aa00";
  };
  buildCommand = ''
    mkdir -p $out/lib/firmware/ath11k/${target}/hw2.0/
    cp $src/QCA6390/hw2.0/1.0.1/WLAN.HST.1.0.1-01740-QCAHSTSWPLZ_V2_TO_X86-1/*.bin $out/lib/firmware/ath11k/QCA6390/hw2.0/
    cp $src/QCA6390/hw2.0/board-2.bin $out/lib/firmware/ath11k/QCA6390/hw2.0/
  '';
  meta = with stdenv.lib; {
    description = ''
      Firmware for the QCA6390 wireless chip.

      This derivation is based on the instructions provided by kvalo in:
      http://lists.infradead.org/pipermail/ath11k/2020-November/000537.html
    '';
    homepage = "https://github.com/kvalo/ath11k-firmware/tree/master/QCA6390/hw2.0";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ mitchmindtree ];
    platforms = platforms.linux;
  };
}
