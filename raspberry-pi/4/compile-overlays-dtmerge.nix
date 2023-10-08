# added this seperate compileDTS due to a change in nixpkgs which seperated `compileDTS`
# see https://github.com/NixOS/nixpkgs/pull/251898
{ lib, stdenv, stdenvNoCC, dtc, libraspberrypi }:

with lib;
# Compile single Device Tree overlay source
# file (.dts) into its compiled variant (.dtb)
({ name
 , dtsFile
 , includePaths ? [ ]
 , extraPreprocessorFlags ? [ ]
 }: stdenv.mkDerivation {
  inherit name;

  nativeBuildInputs = [ dtc ];

  buildCommand =
    let
      includeFlagsStr = lib.concatMapStringsSep " " (includePath: "-I${includePath}") includePaths;
      extraPreprocessorFlagsStr = lib.concatStringsSep " " extraPreprocessorFlags;
    in
    ''
      $CC -E -nostdinc ${includeFlagsStr} -undef -D__DTS__ -x assembler-with-cpp ${extraPreprocessorFlagsStr} ${dtsFile} | \
      dtc -I dts -O dtb -@ -o $out
    '';
})



