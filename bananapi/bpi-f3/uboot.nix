{
  buildUBoot,
  fetchFromGitHub,
}:

buildUBoot {
  version = "2022.10-k1-bl-v2.2.y";

  src = fetchFromGitHub {
    owner = "liberodark";
    repo = "spacemit-uboot-2022.10";
    rev = "72954b3d095acb44be40e72549d22aed1655d42b";
    hash = "sha256-BqnrRkuze2rit2w/xf5i2aMtopzjEQ4zMlDp3P84xMk=";
  };

  defconfig = "k1_defconfig";

  filesToInstall = [ "u-boot.itb" ];

  extraConfig = ''
    CONFIG_SYS_CBSIZE=2048
    CONFIG_SYS_BARGSIZE=2048
  '';
}
