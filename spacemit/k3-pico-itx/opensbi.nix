{
  opensbi,
  fetchFromGitHub,
  buildPackages,
}:

opensbi.overrideAttrs (old: {
  version = "k3-br-v1.0.y";

  src = fetchFromGitHub {
    owner = "liberodark";
    repo = "spacemit-openspi";
    rev = "3e2f9efc9660b8d5fcae4e0b6495f306d5c64078";
    hash = "sha256-pJ9izkJ3eNwF1km335ZjCezWhOSYxOMm1fo/19BoG+I=";
  };

  postPatch = ''
    patchShebangs scripts/
    cp platform/generic/configs/k3_defconfig platform/generic/configs/defconfig
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
