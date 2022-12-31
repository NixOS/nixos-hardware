final: _super:

let
  inherit (final) callPackage;
in
{
  pinebookpro-keyboard-updater = callPackage ./keyboard-updater { };
}
