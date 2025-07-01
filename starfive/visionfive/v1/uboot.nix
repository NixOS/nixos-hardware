{
  fetchFromGitHub,
  buildUBoot,
}:

buildUBoot {
  version = "2022.04";

  src = fetchFromGitHub {
    owner = "Madouura";
    repo = "u-boot";
    rev = "fe61fbcc8c5d3f7a589d2a6ea61855ab77de621f";
    sha256 = "sha256-jMZYxAHB37pNzzLdb8wupZA1CeD0gB84x18B7XVzq/M=";
  };

  defconfig = "starfive_jh7100_visionfive_smode_defconfig";
  filesToInstall = [
    "u-boot.bin"
    "u-boot.dtb"
  ];
}
