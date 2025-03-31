{ fetchFromGitHub
, lib
, stdenv
, ...
}:
stdenv.mkDerivation rec {
  pname = "brcm_patchram_plus";
  version = "2024.11.26";

  src = fetchFromGitHub {
    owner = "orangepi-xunlong";
    repo = "orangepi-build";
    rev = "5f17bb471115d2764b66eeb40b99cd1a885b8be4";
    sha256 = "sha256-gn/y8HVb4pZZNZyQXqhkI3NqNKAfnprfvIp1oSaT05I=";
  };

  sourceRoot = "${src.name}/external/cache/sources/brcm_patchram_plus";

  installPhase = ''
    install -Dm755 brcm_patchram_plus -t $out/bin
  '';

  meta.license = lib.licenses.asl20;
}
