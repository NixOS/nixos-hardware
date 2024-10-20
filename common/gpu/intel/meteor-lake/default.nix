{pkgs, lib, config, ...}: let inherit(lib) mkDefault mkIf; in {
  imports = [ ../. ];

	# only needed to support the i915 driver, can be found using `nix-shell -p pciutils --run "lspci -nn" | grep -oP "VGA.*:\K[0-9a-f]{4}"`
	options.hardware.intelgpu.deviceID = lib.mkOption { description = "Intel GPU to probe"; };

	config = {
		# i915 is buggy on meteor lake, xe should be the default
		hardware.intelgpu.driver = mkDefault "xe";

		# xe driver requires newer kernel
		boot.kernelPackages = mkIf(config.hardware.intelgpu.driver=="xe")( mkDefault pkgs.linuxPackages_latest );

		# workaround that gets the i915 driver working, for those that wish to use it
		boot.kernelParams = mkIf(config.hardware.intelgpu.driver=="i915")[ "i915.force_probe=${config.hardware.intelgpu.deviceID}" ];
	};
}
