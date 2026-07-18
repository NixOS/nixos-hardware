{
  bison,
  buildUBoot,
  fetchFromGitHub,
  flex,
  gnutls,
  lib,
  ncurses,
  openssl,
  tinyxxd,
  which,
}:

buildUBoot {
  pname = "iq-9075-evk-uboot";
  # meta-qcom u-boot-qcom_git.bb: PV = 2026.07+git
  version = "2026.07+git";

  # meta-qcom u-boot-qcom_git.bb SRCREV
  src = fetchFromGitHub {
    owner = "qualcomm-linux";
    repo = "u-boot";
    rev = "e35d929347b19b66db87995724f0fd94be057ff4";
    hash = "sha256-NhsALh5Rpscm2kFhLnHRwuJ+KTnNeqcsqTw9nqfmPAg=";
  };

  # iq-9075-evk → qcom_lemans_defconfig (qcom-u-boot-common.inc)
  defconfig = "qcom_lemans_defconfig";
  # MACHINE_FEATURES += "kvm" → recipes-bsp/u-boot/files/gunyah-exit.cfg
  extraConfig = ''
    CONFIG_QCOM_EL2_GUNYAH_EXIT_SUPPORT=y
    CONFIG_ENABLE_ARM_SOC_BOOT0_HOOK=y
  '';
  extraMeta.platforms = [ "aarch64-linux" ];

  nativeBuildInputs = [
    bison
    flex
    gnutls
    ncurses
    openssl
    tinyxxd
    which
  ];

  # Signed u-boot.mbn needs qtestsign (meta-qcom); ship ELF/bin for now.
  # Type2 ESP/UKI path uses NHLOS uefi.elf; boot.img is unused on this GPT.
  filesToInstall = [
    "u-boot.bin"
    "u-boot-nodtb.bin"
    "u-boot.dtb"
  ];
}
