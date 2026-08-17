{
  opensbi,
  fetchFromGitHub,
  buildPackages,
}:

opensbi.overrideAttrs (old: {
  version = "k1-bl-v2.2.y";

  src = fetchFromGitHub {
    owner = "liberodark";
    repo = "spacemit-openspi";
    rev = "b3c36ed7fb862ac3cdd21062809b0fbbecf302bd";
    hash = "sha256-PIQbqpEnv0kGkYJfyMIzRWwa63Y8leas9s6maYNLAzY=";
  };

  postPatch = ''
    patchShebangs scripts/
    cp platform/generic/configs/k1_defconfig platform/generic/configs/defconfig
  '';

  nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
    buildPackages.ubootTools
    buildPackages.dtc
  ];

  postInstall = ''
    cp build/platform/generic/firmware/fw_dynamic.itb \
       $out/share/opensbi/lp64/generic/firmware/fw_dynamic.itb
  '';
})
