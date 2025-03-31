{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  callPackage,
  dmg2img,
}:

let
  macrecovery = callPackage ./macrecovery.nix { };
in

{
  name,
  boardId,
  mlb,
  osType,
  hash,
}:

stdenvNoCC.mkDerivation {
  name = name;

  dontUnpack = true;

  nativeBuildInputs = [
    macrecovery
    dmg2img
  ];
  buildPhase = ''
    macrecovery download -o . -b ${boardId} -m ${mlb} -os ${osType}
    dmg2img -s BaseSystem.dmg fw.img
  '';

  installPhase = ''
    cp fw.img $out
  '';

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = hash;
}
