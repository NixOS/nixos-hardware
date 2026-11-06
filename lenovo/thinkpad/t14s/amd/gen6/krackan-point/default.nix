{ lib, pkgs, ... }:
{
  imports = [
    ../.
    # Per PSREF, the MT7925 is only used on the Krackan Point platform (models 21TB and 21TC).
    ../../../../../../common/wifi/mediatek/mt7925/default.nix
  ];
}
