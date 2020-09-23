{ buildUBoot, fetchgit }:

buildUBoot rec {
  pname = "uboot-reform2-imx8mq";
  version = "2020-06-01";
  src = fetchgit {
    url = "https://source.mntmn.com/MNT/reform-boundary-uboot.git";
    rev = version;
    sha256 = "0ychnwhisjqm0gzyz0nv9xynl9g114xmxpwz4vm0l5w6sc60jshw";
  };
  defconfig = "nitrogen8m_som_4g_defconfig";
  extraMeta.platforms = [ "aarch64-linux" ];
  filesToInstall = [ "flash.bin" ];
  patches = [ ./shell-syntax.patch ./env_vars.patch ];
  makeFlags = filesToInstall;
}
