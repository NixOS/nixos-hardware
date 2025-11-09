{
  runCommand,
  uboot,
  fetchFromGitHub,
}:
# script from https://source.mnt.re/reform/reform-rk3588-uboot/-/blob/28289e36cd1cb90b302780e83b014250c880c4ec/build.sh
runCommand "mnt-reform-uboot-image-rk3855${uboot.variant}" { } ''
  mkdir $out
  cp ${uboot}/idbloader.img $out/rk3588-mnt-reform2${uboot.variant}-flash.bin
  dd if=${uboot}/u-boot.itb of=$out/rk3588-mnt-reform${uboot.variant}-flash.bin seek=16320
''
