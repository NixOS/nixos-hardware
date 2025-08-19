{
  linuxPackagesFor,
  linuxManualConfig,
  fetchFromGitHub,
}:
linuxPackagesFor (linuxManualConfig rec {
  version = "6.1.75";
  modDirVersion = version;
  src = fetchFromGitHub {
    owner = "Linux-for-Fydetab-Duo";
    repo = "linux-rockchip";
    rev = "74a1657bc526e336ff66add2fa83a0522957c4cb";
    hash = "sha256-Q0uCxebYw3c5Z/ZxCmTNyEfuYQQcPaw5qpvRTSWdtVo=";
  };
  configfile = ./config;
  config = import ./config.nix;
  features.netfilterRPFilter = true;
})
