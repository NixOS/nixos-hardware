# Qualcomm QRB2210 / Arduino Imola (2 GiB RAM, boot from mmc 0:43).
# NixOS puts extlinux + nixos/* on the ESP; flat Image/initrd copies are optional fallback.
setenv kernel_addr_r "0x84000000"
setenv fdt_addr_r "0x48000000"
setenv ramdisk_addr_r "0x82000000"
# Env / DTBO scratch; keep above boot.scr @ 0x8a800000.
setenv load_addr "0x90000000"
setenv overlay_error "false"

setenv devtype "mmc"
setenv devnum "0"
test -n "${distro_bootpart}" || setenv distro_bootpart "43"

setenv rootdev "/dev/mmcblk0p68"
setenv verbosity "1"
setenv console "serial"
setenv bootlogo "false"
setenv rootfstype "ext4"

if test -e ${devtype} ${devnum}:${distro_bootpart} ${prefix}qrb2210Env.txt; then
	load ${devtype} ${devnum}:${distro_bootpart} ${load_addr} ${prefix}qrb2210Env.txt
	env import -t ${load_addr} ${filesize}
fi

if test "${console}" = "display" || test "${console}" = "both"; then setenv consoleargs "console=tty1"; fi
if test "${console}" = "serial" || test "${console}" = "both"; then setenv consoleargs "console=ttyMSM0,115200n8 ${consoleargs}"; fi
if test "${bootlogo}" = "true"; then
	setenv consoleargs "splash plymouth.ignore-serial-consoles ${consoleargs}"
else
	setenv consoleargs "splash=verbose ${consoleargs}"
fi

if test "${devtype}" = "mmc"; then part uuid mmc ${devnum}:${distro_bootpart} partuuid; fi

setenv bootargs "root=${rootdev} rootwait rootfstype=${rootfstype} ${consoleargs} consoleblank=0 loglevel=${verbosity} ubootpart=${partuuid} clk_ignore_unused pd_ignore_unused audit=0 deferred_probe_timeout=30 ${extraargs} ${extraboardargs}"

# Primary: NixOS extlinux on ESP partition root (/extlinux/, not ${prefix}extlinux/…).
sysboot ${devtype} ${devnum}:${distro_bootpart} any ${kernel_addr_r} /extlinux/extlinux.conf

# Fallback: flat Image/initrd/dtbs if sysboot fails. Nix initrd is raw cpio.gz, not uInitrd.
load ${devtype} ${devnum}:${distro_bootpart} ${ramdisk_addr_r} ${prefix}initrd
setenv initrd_size ${filesize}
load ${devtype} ${devnum}:${distro_bootpart} ${kernel_addr_r} ${prefix}Image
load ${devtype} ${devnum}:${distro_bootpart} ${fdt_addr_r} ${prefix}dtbs/${fdtfile}

fdt addr ${fdt_addr_r}
fdt resize 65536
for overlay_file in ${overlays}; do
	if load ${devtype} ${devnum}:${distro_bootpart} ${load_addr} ${prefix}dtbs/qcom/overlay/${overlay_prefix}-${overlay_file}.dtbo; then
		echo "Applying kernel provided DT overlay ${overlay_prefix}-${overlay_file}.dtbo"
		fdt apply ${load_addr} || setenv overlay_error "true"
	fi
done
for overlay_file in ${user_overlays}; do
	if load ${devtype} ${devnum}:${distro_bootpart} ${load_addr} ${prefix}overlay-user/${overlay_file}.dtbo; then
		echo "Applying user provided DT overlay ${overlay_file}.dtbo"
		fdt apply ${load_addr} || setenv overlay_error "true"
	fi
done
if test "${overlay_error}" = "true"; then
	echo "Error applying DT overlays, restoring original DT"
	load ${devtype} ${devnum}:${distro_bootpart} ${fdt_addr_r} ${prefix}dtbs/${fdtfile}
fi

booti ${kernel_addr_r} ${ramdisk_addr_r}:${initrd_size} ${fdt_addr_r}

