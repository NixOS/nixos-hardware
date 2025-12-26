# Shared U-Boot configuration for i.MX platforms
# This configuration is used across i.MX93, i.MX8MP, i.MX8MQ and similar platforms
{
  # Generate common U-Boot extra configuration for i.MX platforms
  # ramdiskAddr and fdtAddr are platform-specific memory addresses
  imxCommonUbootConfig =
    { ramdiskAddr, fdtAddr }:
    ''
      CONFIG_USE_BOOTCOMMAND=y
      CONFIG_BOOTCOMMAND="setenv ramdisk_addr_r ${ramdiskAddr}; setenv fdt_addr_r ${fdtAddr}; run distro_bootcmd; "
      CONFIG_CMD_BOOTEFI_SELFTEST=y
      CONFIG_CMD_BOOTEFI=y
      CONFIG_EFI_LOADER=y
      CONFIG_BLK=y
      CONFIG_PARTITIONS=y
      CONFIG_DM_DEVICE_REMOVE=n
      CONFIG_CMD_CACHE=y
    '';

  # Common U-Boot native build inputs for i.MX platforms
  imxCommonUbootNativeBuildInputs = [
    "bison"
    "flex"
    "openssl"
    "which"
    "ncurses"
    "libuuid"
    "gnutls"
    "openssl"
    "perl"
    "efitools"
  ];
}
