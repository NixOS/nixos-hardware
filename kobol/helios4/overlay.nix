final: _prev: {
  ubootHelios4 = final.buildUBoot rec {
    defconfig = "helios4_defconfig";
    filesToInstall = [ "u-boot-spl.kwb" ];
    # 2021.07 and later are broken, similar to this bug report:
    # https://www.mail-archive.com/u-boot@lists.denx.de/msg451013.html#
    version = "2021.04";
    src = final.fetchFromGitHub {
      owner = "u-boot";
      repo = "u-boot";
      rev = "v${version}";
      sha256 = "sha256-QxrTPcx0n0NWUJ990EuIWyOBtknW/fHDRcrYP0yQzTo=";
    };
    patches = [];
  };
}
