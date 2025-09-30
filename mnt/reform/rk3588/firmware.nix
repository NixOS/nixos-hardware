{
  runCommand,
  uboot,
  fetchFromGitHub,
}:
# script from https://source.mnt.re/reform/reform-rk3588-uboot/-/blob/b530d65f4a878c0329a594fa248ba8da59d2e05f/build.sh
runCommand "mnt-reform-firmware-rk3855${uboot.variant}" { } ''
  mkdir $out
  cp -r ${uboot} u-boot
  cp -r ${uboot.rkbin} rkbin
  chmod -R +rw u-boot
  chmod -R +rw rkbin
  cd u-boot
  mkdir spl
  mv u-boot-spl.bin spl
  ../rkbin/tools/boot_merger rock5b-rk3588.ini
  cd ..
  # rkbin stuff
  cd rkbin
  ./tools/boot_merger RKBOOT/RK3588MINIALL.ini
  # concatenate
  cd ..
  cp u-boot/idbloader.img $out/mnt-reform2-rk3588${uboot.variant}-flash.bin
  dd if=u-boot/u-boot.itb of=$out/mnt-reform2-rk3588${uboot.variant}-flash.bin seek=16320
''
