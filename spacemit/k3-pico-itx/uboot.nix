{
  buildUBoot,
  fetchFromGitHub,
}:

buildUBoot {
  version = "2022.10-k3-br-v1.0.y";

  src = fetchFromGitHub {
    owner = "liberodark";
    repo = "spacemit-uboot-2022.10";
    rev = "368953aa0b648528ddafa5b6baa73507448ab94d";
    hash = "sha256-LTtxHzL5aoMLlv8DsgEoyIM0JrwYYzNlHCAmXzixScI=";
  };

  defconfig = "k3_defconfig";

  filesToInstall = [ "u-boot.itb" ];

  extraConfig = ''
    CONFIG_SYS_CBSIZE=2048
    CONFIG_SYS_BARGSIZE=2048
  '';
}
