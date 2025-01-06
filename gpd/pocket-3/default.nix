{ lib, pkgs, ... }:
let inherit (lib) mkDefault mkIf;
in
{
	imports = [
		../../common/pc/laptop
		../../common/pc/laptop/ssd
    ../../common/hidpi.nix
    ../../common/gpu/24.05-compat.nix
	];

  # Necessary kernel modules
	boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "thunderbolt" ];

	# GPU is an Intel Iris Xe, on a “TigerLake” mobile CPU
	boot.initrd.kernelModules = [ "i915" ];  # Early loading so the passphrase prompt appears on external displays
	hardware.graphics.extraPackages = with pkgs; [
		intel-media-driver
		(if (lib.versionOlder (lib.versions.majorMinor lib.version) "23.11") then vaapiIntel else intel-vaapi-driver)
	];

	boot.kernelParams = [
		# The GPD Pocket3 uses a tablet OLED display, that is mounted rotated 90° counter-clockwise
		"fbcon=rotate:1" "video=DSI-1:panel_orientation=right_side_up"
	];

	fonts.fontconfig = {
		subpixel.rgba = "vbgr";  # Pixel order for rotated screen

		# The OLED display has √(1920² + 1200²) px / 8in ≃ 283 dpi
		# Per the documentation, antialiasing, hinting, etc. have no visible effect at such high pixel densities anyhow.
		# Set manually, as the hiDPI module had incorrect settings prior to NixOS 22.11; see nixpkgs#194594.
		hinting.enable = mkDefault false;
		antialias = mkIf (lib.versionOlder (lib.versions.majorMinor lib.version) "22.11") false;
	};

	# More HiDPI settings
	services.xserver.dpi = 280;

	# Necessary for audio support on the 1195G7 model
	boot.extraModprobeConfig = ''
		options snd-intel-dspcfg dsp_driver=1
	'';
}
