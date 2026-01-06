{
  lib,
  writeShellApplication,
  config,
}:
let
  dev = "/dev/" + config.mmc + lib.optionalString config.mmcBoot0 "boot0";
in
writeShellApplication {
  name = "reform-flash-uboot";
  text = ''
    if [ "$(id -u)" -ne 0 ]; then
      echo "reform-flash-uboot has to be run as root / using sudo."
      exit 1
    fi
  ''
  + lib.optionalString config.warn ''
    echo "W: Flashing u-boot to eMMC on $(cat /proc/device-tree/model) is not without risk." >&2
    echo "W: If you flash the wrong u-boot or if the flashing process goes wrong, it is" >&2
    echo "W: possible to soft-brick your board. Restoring it might need some extra hardware." >&2
    echo "W: Please only proceed if you are sure that the benefits outweigh the risks for you." >&2
    printf "Are you sure you want to proceed? [y/N] "
    read -r response

    if [ "$response" != "y" ]; then
      echo "Exiting."
      exit
    fi
  ''
  + ''
    echo "Writing ${config.image} to ${dev}" >&2
  ''
  + lib.optionalString config.mmcBoot0 ''
    echo 0 >"/sys/class/block/${config.mmc}boot0/force_ro"
  ''
  + ''
    dd if='${config.image}' of='${dev}' bs=512 seek='${
      builtins.toString (config.ubootOffset / 512)
    }' skip='${builtins.toString (config.flashbinOffset / 512)}'
  ''
  + lib.optionalString config.mmcBoot0 ''
    echo 1 >"/sys/class/block/${config.mmc}boot0/force_ro"
  '';
}
